# MCP Integration - Complete Setup

## Available MCP Servers

Your system now has **3 MCP servers** that can be used by Claude Desktop, Warp, and other MCP clients:

### 1. n8n Workflows MCP
**URL:** `http://localhost:5678/mcp-server/http`

**Capabilities:**
- Execute n8n workflows
- List available workflows
- Monitor workflow executions
- Trigger webhooks

**Use case:** Run automation workflows directly from Claude/Warp

### 2. Warp Memory MCP
**Location:** `C:\Users\bermi\Projects\warp-memory-mcp`

**Capabilities:**
- Read centralized memory
- Update memory fields
- Log events to memory
- Mark actions complete

**Use case:** Universal memory access across all AI systems

### 3. Agent Agency MCP
**Location:** `C:\Users\bermi\Projects\agent-agency-mcp`

**Capabilities:**
- Delegate tasks to agents
- Monitor agent status
- Query knowledge base
- Create new agents
- View agent logs

**Use case:** Interact with your n8n-based agent system

## Configuration Files

### For Warp

Location: Check Warp settings for MCP configuration

```json
{
  "mcpServers": {
    "warp-memory": {
      "command": "node",
      "args": ["C:\\Users\\bermi\\Projects\\warp-memory-mcp\\dist\\index.js"],
      "env": {
        "MEMORY_API_URL": "http://localhost:8766"
      }
    },
    "agent-agency": {
      "command": "node",
      "args": ["C:\\Users\\bermi\\Projects\\agent-agency-mcp\\dist\\index.js"],
      "env": {
        "N8N_URL": "http://localhost:5678",
        "N8N_API_KEY": "your_key_here"
      }
    }
  }
}
```

### For Claude Desktop

Location: `%APPDATA%\Claude\claude_desktop_config.json`

Use the same configuration as above, or just the MCP servers you want to use.

## Testing MCP Connections

### Test n8n MCP
```bash
curl http://localhost:5678/mcp-server/http
```

### Test Memory MCP
```bash
# Start the MCP server
node C:\Users\bermi\Projects\warp-memory-mcp\dist\index.js

# In another terminal, test the memory API
curl http://localhost:8766/api/memory
```

### Test Agent Agency MCP
```bash
# Ensure PostgreSQL and n8n are running
docker-compose ps

# Start the MCP server
node C:\Users\bermi\Projects\agent-agency-mcp\dist\index.js
```

## Integration Architecture

```
┌─────────────────────────────────────────┐
│         Claude Desktop / Warp           │
└─────────────────┬───────────────────────┘
                  │ MCP Protocol
         ┌────────┼────────┐
         │        │        │
    ┌────▼───┐ ┌─▼──────┐ ┌▼────────────┐
    │ n8n    │ │ Memory │ │ Agent       │
    │ MCP    │ │ MCP    │ │ Agency MCP  │
    └────┬───┘ └─┬──────┘ └┬────────────┘
         │       │          │
    ┌────▼───────▼──────────▼────┐
    │   Docker Services           │
    │  - n8n (5678)              │
    │  - Memory API (8766)       │
    │  - PostgreSQL (5432)       │
    └────────────────────────────┘
```

## Usage Examples

### From Claude Desktop

Once configured, you can say:

```
"Check my current memory state"
→ Uses Warp Memory MCP to read from localhost:8766

"Create a new agent for email processing"
→ Uses Agent Agency MCP to create agent in n8n

"Execute the morning autopilot workflow"
→ Uses n8n MCP to trigger workflow
```

### From Warp

```
"Update memory with today's completed tasks"
→ Uses warp-memory MCP

"Show me active agents"
→ Uses agent-agency MCP

"List all n8n workflows"
→ Uses n8n MCP (if configured)
```

## Environment Variables Summary

All MCP servers share these:

```env
# n8n Connection
N8N_URL=http://localhost:5678
N8N_API_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# PostgreSQL Connection
DB_HOST=localhost
DB_PORT=5432
DB_NAME=agent_system
DB_USER=postgres
DB_PASSWORD=postgres_secure_2024

# Memory Service
MEMORY_API_URL=http://localhost:8766
```

## Troubleshooting

### MCP Server Not Starting

```powershell
# Check if dependencies are built
cd C:\Users\bermi\Projects\warp-memory-mcp
npm run build

cd C:\Users\bermi\Projects\agent-agency-mcp
npm run build
```

### Can't Connect to Services

```powershell
# Verify Docker services are running
docker-compose ps

# Restart if needed
docker-compose restart
```

### Permission Errors

Make sure MCP servers can access:
- Node.js is in PATH
- Docker services are accessible
- API keys are valid

## Security Notes

- API keys are stored in .env files - keep them secure
- MCP servers run locally on your machine
- Services only accessible via localhost by default
- Consider firewall rules if exposing externally

---

**Co-Authored-By: Warp <agent@warp.dev>**
