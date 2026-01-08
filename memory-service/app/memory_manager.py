"""
Memory Manager - Core logic for memory operations
Handles deduplication, event classification, and auto-merge strategies
"""
import json
import asyncio
from pathlib import Path
from typing import Dict, Any, List, Optional
from datetime import datetime
from dateutil import parser as date_parser
import aiofiles

class MemoryManager:
    def __init__(self, memory_file: Path):
        self.memory_file = memory_file
        self._lock = asyncio.Lock()
        
    async def read_memory(self) -> Dict[str, Any]:
        """Read current memory state from file"""
        async with self._lock:
            if not self.memory_file.exists():
                return self._get_default_memory()
            
            async with aiofiles.open(self.memory_file, 'r', encoding='utf-8') as f:
                content = await f.read()
                return json.loads(content)
    
    async def write_memory(self, data: Dict[str, Any]) -> None:
        """Write memory state to file"""
        async with self._lock:
            # Ensure directory exists
            self.memory_file.parent.mkdir(parents=True, exist_ok=True)
            
            # Update last_updated timestamp
            data['last_updated'] = datetime.utcnow().isoformat()
            
            async with aiofiles.open(self.memory_file, 'w', encoding='utf-8') as f:
                await f.write(json.dumps(data, indent=2))
    
    async def update_memory(self, updates: Dict[str, Any], source: str) -> Dict[str, Any]:
        """Update specific fields in memory"""
        memory = await self.read_memory()
        
        # Deep merge updates into memory
        memory = self._deep_merge(memory, updates)
        
        # Add source tracking
        if 'update_history' not in memory:
            memory['update_history'] = []
        
        memory['update_history'].append({
            'timestamp': datetime.utcnow().isoformat(),
            'source': source,
            'fields_updated': list(updates.keys())
        })
        
        # Keep only last 50 history entries
        memory['update_history'] = memory['update_history'][-50:]
        
        await self.write_memory(memory)
        return memory
    
    async def process_event(self, event) -> Dict[str, Any]:
        """Process an event and update memory accordingly"""
        memory = await self.read_memory()
        
        event_type = event.event_type
        event_data = event.data
        source = event.source
        
        # Classify and route event
        if event_type in ['agent_created', 'workflow_created']:
            memory = await self._handle_agent_event(memory, event_data, source)
        elif event_type in ['project_created', 'project_completed']:
            memory = await self._handle_project_event(memory, event_data, source)
        elif event_type in ['tool_added', 'tool_status_change']:
            memory = await self._handle_tool_event(memory, event_data, source)
        elif event_type in ['component_completed']:
            memory = await self._handle_component_event(memory, event_data, source)
        else:
            # Generic event handling
            if 'events' not in memory:
                memory['events'] = []
            memory['events'].append({
                'type': event_type,
                'source': source,
                'data': event_data,
                'timestamp': datetime.utcnow().isoformat()
            })
            memory['events'] = memory['events'][-100:]  # Keep last 100 events
        
        await self.write_memory(memory)
        return memory
    
    async def complete_action(self, action_id: str) -> Dict[str, Any]:
        """Mark a next_action as completed"""
        memory = await self.read_memory()
        
        if 'next_actions' in memory:
            memory['next_actions'] = [
                action for action in memory['next_actions'] 
                if action != action_id
            ]
        
        if 'completed_actions' not in memory:
            memory['completed_actions'] = []
        
        memory['completed_actions'].append({
            'action': action_id,
            'completed_at': datetime.utcnow().isoformat()
        })
        
        await self.write_memory(memory)
        return memory
    
    async def _handle_agent_event(self, memory: Dict, event_data: Dict, source: str) -> Dict:
        """Handle agent/workflow creation events"""
        agent_name = event_data.get('name') or event_data.get('agent_name')
        
        if 'system_state' not in memory:
            memory['system_state'] = {}
        
        if 'existing_projects' not in memory['system_state']:
            memory['system_state']['existing_projects'] = []
        
        # Check for duplicates
        existing = [p for p in memory['system_state']['existing_projects'] if agent_name in p]
        
        if not existing:
            description = event_data.get('description', f"{agent_name} via {source}")
            memory['system_state']['existing_projects'].append(f"{agent_name} - {description}")
        
        return memory
    
    async def _handle_project_event(self, memory: Dict, event_data: Dict, source: str) -> Dict:
        """Handle project lifecycle events"""
        project_name = event_data.get('name') or event_data.get('title')
        
        if event_data.get('completed'):
            if 'completed_components' not in memory:
                memory['completed_components'] = []
            
            if project_name not in memory['completed_components']:
                memory['completed_components'].append(project_name)
        
        return memory
    
    async def _handle_tool_event(self, memory: Dict, event_data: Dict, source: str) -> Dict:
        """Handle tool status changes"""
        tool_name = event_data.get('tool_name')
        status = event_data.get('status')
        
        if 'tool_status' not in memory:
            memory['tool_status'] = {}
        
        memory['tool_status'][tool_name] = status
        
        return memory
    
    async def _handle_component_event(self, memory: Dict, event_data: Dict, source: str) -> Dict:
        """Handle component completion events"""
        component = event_data.get('component')
        
        if 'completed_components' not in memory:
            memory['completed_components'] = []
        
        if component and component not in memory['completed_components']:
            memory['completed_components'].append(component)
        
        return memory
    
    def _deep_merge(self, base: Dict, updates: Dict) -> Dict:
        """Deep merge two dictionaries"""
        result = base.copy()
        
        for key, value in updates.items():
            if key in result and isinstance(result[key], dict) and isinstance(value, dict):
                result[key] = self._deep_merge(result[key], value)
            elif key in result and isinstance(result[key], list) and isinstance(value, list):
                # For lists, use deduplication
                result[key] = self._deduplicate_list(result[key] + value)
            else:
                result[key] = value
        
        return result
    
    def _deduplicate_list(self, items: List) -> List:
        """Remove duplicates from list while preserving order"""
        seen = set()
        result = []
        
        for item in items:
            # Convert to string for hashable comparison
            item_str = json.dumps(item, sort_keys=True) if isinstance(item, (dict, list)) else str(item)
            if item_str not in seen:
                seen.add(item_str)
                result.append(item)
        
        return result
    
    def _get_default_memory(self) -> Dict[str, Any]:
        """Get default memory structure"""
        return {
            "current_goal": "Build self-maintaining autonomous agent agency system",
            "completed_components": [],
            "system_state": {
                "n8n_instance": "http://192.168.50.246:5678",
                "existing_projects": []
            },
            "user": "bermi",
            "tool_status": {},
            "last_updated": datetime.utcnow().isoformat(),
            "next_actions": []
        }
