# Migration to Docker n8n - COMPLETE

## ✅ What Was Migrated

### 1. Claude Desktop Configuration
**File:** `%APPDATA%\Claude\claude_desktop_config.json`

**Changes:**
- ✅ `agent-agency` MCP now uses `http://localhost:5678` (was QNAP)
- ✅ Updated to new n8n API key
- ✅ PostgreSQL password updated to `postgres_secure_2024`
- ✅ Replaced `memory` MCP with `warp-memory` MCP (connects to Memory API)

**Backup:** `claude_desktop_config.json.backup.[timestamp]`

### 2. Agent Agency MCP
**File:** `C:\Users\bermi\Projects\agent-agency-mcp\.env`

**Changes:**
- ✅ `N8N_URL=http://localhost:5678` (was 192.168.50.246:5678)
- ✅ New n8n API key
- ✅ Database credentials updated

### 3. Bermech Workflows
**File:** `C:\Users\bermi\Projects\bermech-n8n-workflows\.env`

**Changes:**
- ✅ n8n URL updated to `localhost:5678`

### 4. Workflows Imported
- ✅ 68 of 69 workflows successfully imported
- ✅ Memory Service MCP workflow created and activated

## ⚠️ Manual Updates Needed

### 1. Workflow with QNAP Reference
**Workflow:** "Midjourney Automation Receiver"

This workflow contains a hardcoded reference to `192.168.50.246`. To fix:

1. Open workflow in n8n: http://localhost:5678
2. Search for nodes with `192.168.50.246`
3. Replace with `localhost` or appropriate service name
4. Save workflow

### 2. Credentials Setup
Complete the credential setup as documented in `CREDENTIALS_SETUP.md`:

- Notion API
- PostgreSQL
- OpenAI/Claude (if used)

### 3. Test Critical Workflows
After setting up credentials, test these workflows:
- Morning/Evening Autopilot
- Agent creation workflows
- Any workflows using external APIs

## 🔄 Services Now Using Docker n8n

| Service/Tool | Old URL | New URL | Status |
|--------------|---------|---------|--------|
| Claude Desktop MCP | 192.168.50.246:5678 | localhost:5678 | ✅ Updated |
| Agent Agency MCP | 192.168.50.246:5678 | localhost:5678 | ✅ Updated |
| Warp Memory MCP | Static file | localhost:8766 API | ✅ Updated |
| Bermech Workflows | 192.168.50.246:5678 | localhost:5678 | ✅ Updated |

## 📊 Architecture Change

### Before (QNAP)
```
Claude/Warp → QNAP n8n (192.168.50.246:5678)
              ↓
              QNAP PostgreSQL
```

### After (Docker)
```
Claude/Warp → Docker n8n (localhost:5678)
              ↓
              Docker PostgreSQL (localhost:5432)
              ↓
              Memory Service (localhost:8766)
```

## 🎯 Benefits

1. **Local Development:** Everything runs on your machine
2. **Version Control:** Docker Compose configuration in git
3. **Easy Backup:** Simple docker volume backups
4. **Memory Integration:** Centralized memory service with MCP
5. **Faster:** No network latency to QNAP

## 🔧 Quick Commands

```powershell
# Start all services
cd C:\Users\bermi\Projects\ai-governance
docker-compose up -d

# Check service status
docker-compose ps

# View logs
docker-compose logs -f n8n

# Restart Claude Desktop (to reload MCP config)
# Close and reopen Claude Desktop app

# Test Memory MCP
curl http://localhost:8766/api/memory
```

## 📝 Next Steps

1. ⬜ Set up credentials in n8n
2. ⬜ Fix "Midjourney Automation Receiver" workflow
3. ⬜ Test critical workflows
4. ⬜ Stop QNAP n8n (when confirmed working)
5. ⬜ Update Warp global rules (if configured)

## 🛡️ Rollback (If Needed)

If you need to rollback to QNAP n8n:

1. Restore Claude config:
   ```powershell
   $backup = Get-ChildItem "$env:APPDATA\Claude\claude_desktop_config.json.backup.*" | Sort-Object -Descending | Select-Object -First 1
   Copy-Item $backup.FullName "$env:APPDATA\Claude\claude_desktop_config.json"
   ```

2. Restore agent-agency .env from git history

3. Start QNAP n8n container

## 📞 Support Files

- `SETUP_COMPLETE.md` - Full setup documentation
- `CREDENTIALS_SETUP.md` - Credential configuration guide
- `MCP_INTEGRATION.md` - MCP server integration guide
- `MIGRATION_GUIDE.md` - Original migration steps

---

**Migration completed:** 2025-12-21  
**Co-Authored-By: Warp <agent@warp.dev>**
