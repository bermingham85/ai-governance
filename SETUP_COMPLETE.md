# Docker n8n Setup - Complete

## ✅ What's Running

Your complete AI automation stack is now running in Docker:

| Service | Port | Status | URL |
|---------|------|--------|-----|
| n8n | 5678 | ✅ Running | http://localhost:5678 |
| PostgreSQL | 5432 | ✅ Running | localhost:5432 |
| Memory Service | 8766 | ✅ Running | http://localhost:8766 |

## 📦 What's Ready

- **69 workflows exported** from QNAP n8n → `n8n-export/workflows.json`
- **n8n admin account** created:
  - Email: `admin@local.dev`
  - Password: `admin123`
  - ⚠️ Change this after first login!
- **Memory Service workflow** template → `memory-service-workflow.json`

## 🚀 Next Steps

### 1. Import Workflows

```powershell
# Method 1: Run import script
.\import-workflows.ps1

# Method 2: Manual import via UI
# 1. Go to http://localhost:5678
# 2. Login with admin@local.dev / admin123
# 3. Create API key at Settings → API
# 4. Run: .\import-workflows.ps1 -ApiKey "your_key"
```

### 2. Import Memory Service Workflow

This workflow enables automatic memory updates when agents are created:

1. In n8n, click **Workflows** → **Import from File**
2. Select `memory-service-workflow.json`
3. Activate the workflow
4. Test with manual trigger

**Webhook URL:** `http://localhost:5678/webhook/agent-created`

### 3. Configure Warp Memory MCP

Update Warp to use the new memory service:

```json
{
  "mcpServers": {
    "warp-memory": {
      "command": "node",
      "args": ["C:\\Users\\bermi\\Projects\\warp-memory-mcp\\dist\\index.js"],
      "env": {
        "MEMORY_API_URL": "http://localhost:8766"
      }
    }
  }
}
```

### 4. Update Agent Agency MCP

Update the agent-agency-mcp to use Docker n8n:

**File:** `C:\Users\bermi\Projects\agent-agency-mcp\.env`

```env
N8N_URL=http://localhost:5678
N8N_API_KEY=your_new_api_key_here
```

### 5. Configure Credentials

Workflows that need credentials must be reconfigured:

**Common credentials needed:**
- OpenAI API (for AI nodes)
- Anthropic/Claude API
- Notion API
- PostgreSQL connection
- Any custom service APIs

**To configure:**
1. Go to Settings → Credentials
2. Click "Add Credential"
3. Enter secrets for each service
4. Update workflows to use new credentials

### 6. Test Workflows

For each imported workflow:
1. Open workflow
2. Check for credential warnings
3. Click "Execute Workflow"
4. Verify output is correct

### 7. Update Global Rules

Update your Warp rules:

**Old:**
```
n8n instance: http://192.168.50.246:5678
```

**New:**
```
n8n instance: http://localhost:5678
```

## 🔧 Management Commands

```powershell
# View all service logs
docker-compose logs -f

# Restart n8n
docker-compose restart n8n

# Stop everything
docker-compose down

# Fresh start (removes all data!)
docker-compose down -v
docker-compose up -d

# Backup workflows
docker exec n8n-docker n8n export:workflow --all --output=/tmp/backup.json
docker cp n8n-docker:/tmp/backup.json ./n8n-backup.json

# Backup database
docker exec ai-postgres pg_dump -U postgres agent_system > backup.sql
```

## 🔗 Integration Points

### Memory Service Integration

All services can now auto-update memory:

**From n8n workflows:**
```
POST http://memory-service:8765/api/memory/events
{
  "event_type": "agent_created",
  "source": "n8n",
  "data": { "name": "agent_name" }
}
```

**From Warp (via MCP):**
- Use `update_memory` tool
- Use `log_event` tool

**From AI Orchestrator:**
```javascript
await fetch('http://localhost:8766/api/memory/events', {
  method: 'POST',
  body: JSON.stringify({
    event_type: 'project_completed',
    source: 'orchestrator',
    data: { name: 'MyProject' }
  })
});
```

## 📊 Monitoring

### Check Service Health

```powershell
# All services
docker-compose ps

# n8n logs
docker logs -f n8n-docker

# Memory service
curl http://localhost:8766/

# PostgreSQL
docker exec ai-postgres psql -U postgres -d agent_system -c "\dt"
```

### Memory Service Dashboard

View current memory state:
```powershell
curl http://localhost:8766/api/memory | ConvertFrom-Json | ConvertTo-Json -Depth 10
```

## 🛡️ Security Notes

1. **Change default password** for n8n admin account
2. **Rotate API keys** after migration is complete
3. **Backup credentials** securely (they're in Docker volumes)
4. Consider enabling **n8n authentication** for production use

## 🎯 Success Criteria

- [ ] All 69 workflows imported
- [ ] Credentials configured
- [ ] Memory Service workflow active
- [ ] Warp MCP connected to new memory API
- [ ] Agent Agency MCP using Docker n8n
- [ ] QNAP n8n stopped
- [ ] Global rules updated

---

**Co-Authored-By: Warp <agent@warp.dev>**
