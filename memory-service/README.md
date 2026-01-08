# Memory Service - Universal Source of Truth

Central memory service that provides a single source of truth for all AI systems (Claude, Warp, n8n, AI Orchestrator, etc.)

## Features

- **REST API** for memory read/write operations
- **WebSocket** for real-time memory synchronization
- **Event Processing** with automatic classification and routing
- **Deduplication** to prevent duplicate entries
- **Update History** tracking with source attribution
- **Auto-merge** strategy for concurrent updates

## Architecture

```
Memory Service (Port 8765)
    ↓
memory.json (C:\Users\bermi\.ai_context\memory.json)
    ↑
All AI Systems (Claude, Warp, n8n, etc.)
```

## Installation

```bash
cd C:\Users\bermi\Projects\ai-governance\memory-service
pip install -r requirements.txt
```

## Running the Service

```bash
python -m app.main
```

Or with uvicorn directly:

```bash
uvicorn app.main:app --host 0.0.0.0 --port 8765 --reload
```

## API Endpoints

### GET /api/memory
Retrieve current memory state

**Response:**
```json
{
  "success": true,
  "data": { ... },
  "timestamp": "2025-12-20T17:00:00Z"
}
```

### POST /api/memory
Update memory fields

**Request:**
```json
{
  "updates": {
    "current_goal": "New goal",
    "tool_status": {"new_tool": "working"}
  },
  "source": "warp"
}
```

### POST /api/memory/events
Log an event (auto-updates memory)

**Request:**
```json
{
  "event_type": "agent_created",
  "source": "n8n",
  "data": {
    "name": "email_processor",
    "description": "Processes incoming emails"
  }
}
```

**Supported event types:**
- `agent_created`, `workflow_created`
- `project_created`, `project_completed`
- `tool_added`, `tool_status_change`
- `component_completed`

### PUT /api/memory/complete-action
Mark an action as completed

**Query param:** `action_id`

### WebSocket /ws/memory
Real-time memory synchronization

Connect and receive:
1. Initial memory state
2. Real-time updates when memory changes

## Integration Examples

### From Warp (PowerShell)
```powershell
# Read memory
curl http://localhost:8765/api/memory

# Update memory
curl -X POST http://localhost:8765/api/memory `
  -H "Content-Type: application/json" `
  -d '{"updates": {"current_goal": "New goal"}, "source": "warp"}'
```

### From n8n Workflow
Use HTTP Request node:
- Method: POST
- URL: `http://localhost:8765/api/memory/events`
- Body:
```json
{
  "event_type": "agent_created",
  "source": "n8n",
  "data": {
    "name": "{{ $json.agent_name }}",
    "description": "{{ $json.description }}"
  }
}
```

### From Node.js (AI Orchestrator)
```javascript
const response = await fetch('http://localhost:8765/api/memory/events', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    event_type: 'project_completed',
    source: 'orchestrator',
    data: { name: 'MyProject', completed: true }
  })
});
```

## Development

### Run in dev mode with auto-reload
```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8765
```

### Test the API
```bash
# Health check
curl http://localhost:8765/

# Get memory
curl http://localhost:8765/api/memory
```

## Next Steps

1. ✅ Memory Service API
2. ⏳ Warp MCP Server integration
3. ⏳ n8n webhook workflow
4. ⏳ AI Orchestrator middleware
5. ⏳ Claude Desktop MCP adapter

## Related Files

- Memory file: `C:\Users\bermi\.ai_context\memory.json`
- GLOBAL_AI_RULES: `C:\Users\bermi\Projects\ai-governance\GLOBAL_AI_RULES.md`

---

**Co-Authored-By: Warp <agent@warp.dev>**
