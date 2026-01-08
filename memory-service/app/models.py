"""
Pydantic models for Memory Service API
"""
from pydantic import BaseModel, Field
from typing import Dict, Any, Optional, List
from datetime import datetime

class MemoryUpdate(BaseModel):
    """Request model for memory updates"""
    updates: Dict[str, Any] = Field(..., description="Fields to update in memory")
    source: str = Field(..., description="Source system making the update (e.g., 'warp', 'claude', 'n8n')")

class MemoryEvent(BaseModel):
    """Event model for logging activities"""
    event_type: str = Field(..., description="Type of event (e.g., 'agent_created', 'project_completed', 'tool_added')")
    source: str = Field(..., description="System that generated the event")
    data: Dict[str, Any] = Field(..., description="Event-specific data")
    timestamp: Optional[str] = Field(None, description="Event timestamp (auto-generated if not provided)")

class MemoryResponse(BaseModel):
    """Response model for API calls"""
    success: bool
    data: Optional[Dict[str, Any]] = None
    message: Optional[str] = None
    timestamp: str = Field(default_factory=lambda: datetime.utcnow().isoformat())
