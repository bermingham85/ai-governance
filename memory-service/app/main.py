"""
Memory Service - Central Source of Truth for All AI Systems
Provides REST API and WebSocket interface for memory operations
"""
from fastapi import FastAPI, WebSocket, WebSocketDisconnect, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from typing import Optional, Dict, Any, List
from datetime import datetime
import json
import asyncio
from pathlib import Path

from .memory_manager import MemoryManager
from .models import MemoryUpdate, MemoryEvent, MemoryResponse

app = FastAPI(title="Memory Service", version="1.0.0")

# CORS configuration for cross-origin access
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure appropriately for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize memory manager
import os
memory_file = Path(os.path.expanduser("~/.ai_context/memory.json")).resolve()
manager = MemoryManager(memory_file)

# WebSocket connection manager
class ConnectionManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def broadcast(self, message: dict):
        for connection in self.active_connections:
            try:
                await connection.send_json(message)
            except:
                pass  # Connection might be closed

ws_manager = ConnectionManager()

@app.get("/")
async def root():
    """Health check endpoint"""
    return {"status": "operational", "service": "memory-service", "version": "1.0.0"}

@app.get("/api/memory", response_model=MemoryResponse)
async def get_memory():
    """Retrieve current memory state"""
    try:
        data = await manager.read_memory()
        return MemoryResponse(success=True, data=data)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/memory")
async def update_memory(update: MemoryUpdate):
    """Update specific fields in memory"""
    try:
        result = await manager.update_memory(update.updates, update.source)
        
        # Broadcast to all connected WebSocket clients
        await ws_manager.broadcast({
            "type": "memory_update",
            "data": result,
            "source": update.source,
            "timestamp": datetime.utcnow().isoformat()
        })
        
        return MemoryResponse(success=True, data=result, message="Memory updated successfully")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/memory/events")
async def log_event(event: MemoryEvent):
    """Log an event and update memory accordingly"""
    try:
        result = await manager.process_event(event)
        
        # Broadcast event to WebSocket clients
        await ws_manager.broadcast({
            "type": "memory_event",
            "event": event.dict(),
            "timestamp": datetime.utcnow().isoformat()
        })
        
        return MemoryResponse(success=True, data=result, message=f"Event '{event.event_type}' processed")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.put("/api/memory/complete-action")
async def complete_action(action_id: str):
    """Mark a next_action as completed"""
    try:
        result = await manager.complete_action(action_id)
        
        await ws_manager.broadcast({
            "type": "action_completed",
            "action_id": action_id,
            "timestamp": datetime.utcnow().isoformat()
        })
        
        return MemoryResponse(success=True, data=result, message="Action marked complete")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.websocket("/ws/memory")
async def websocket_endpoint(websocket: WebSocket):
    """WebSocket endpoint for real-time memory sync"""
    await ws_manager.connect(websocket)
    try:
        # Send current memory state on connection
        data = await manager.read_memory()
        await websocket.send_json({
            "type": "initial_state",
            "data": data,
            "timestamp": datetime.utcnow().isoformat()
        })
        
        # Keep connection alive and listen for messages
        while True:
            message = await websocket.receive_json()
            # Echo back for debugging
            await websocket.send_json({"type": "ack", "received": message})
    except WebSocketDisconnect:
        ws_manager.disconnect(websocket)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8765)
