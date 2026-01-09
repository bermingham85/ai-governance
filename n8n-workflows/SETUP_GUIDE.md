# n8n Workflows Setup Guide

**Purpose:** ChatGPT context and rules webhook endpoints  
**Created:** 2026-01-09

---

## Workflows Included

1. **`chatgpt-context-provider.json`**
   - Endpoint: `GET /webhook/chatgpt-context`
   - Returns: Memory, goals, projects, tool status
   
2. **`chatgpt-rules-provider.json`**
   - Endpoint: `GET /webhook/chatgpt-rules`
   - Returns: Governance rules summary

---

## Prerequisites

- n8n instance running at: http://192.168.50.246:5678
- Memory Service running at: http://localhost:8765
- GLOBAL_AI_RULES.md file accessible at: `C:\Users\bermi\Projects\ai-governance\GLOBAL_AI_RULES.md`

---

## Import Instructions

### Method 1: Via n8n Web UI

1. Open n8n: http://192.168.50.246:5678
2. Click **"Workflows"** in left sidebar
3. Click **"Add workflow"** → **"Import from file"**
4. Select `chatgpt-context-provider.json`
5. Click **"Save"**
6. Repeat steps 3-5 for `chatgpt-rules-provider.json`

### Method 2: Via n8n API

```powershell
# Import context provider
$contextWorkflow = Get-Content "C:\Users\bermi\Projects\ai-governance\n8n-workflows\chatgpt-context-provider.json" -Raw
Invoke-RestMethod -Method POST -Uri "http://192.168.50.246:5678/api/v1/workflows" `
  -Headers @{"X-N8N-API-KEY"="YOUR_API_KEY"} `
  -ContentType "application/json" `
  -Body $contextWorkflow

# Import rules provider  
$rulesWorkflow = Get-Content "C:\Users\bermi\Projects\ai-governance\n8n-workflows\chatgpt-rules-provider.json" -Raw
Invoke-RestMethod -Method POST -Uri "http://192.168.50.246:5678/api/v1/workflows" `
  -Headers @{"X-N8N-API-KEY"="YOUR_API_KEY"} `
  -ContentType "application/json" `
  -Body $rulesWorkflow
```

---

## Activation

After importing, **activate both workflows**:

1. Open each workflow in n8n
2. Click **"Active"** toggle in top-right
3. Verify webhook URLs are generated:
   - `http://192.168.50.246:5678/webhook/chatgpt-context`
   - `http://192.168.50.246:5678/webhook/chatgpt-rules`

---

## Testing

### Test Context Endpoint

```powershell
curl http://192.168.50.246:5678/webhook/chatgpt-context
```

**Expected Response:**
```json
{
  "memory": {...},
  "governance_summary": {
    "rules": "RULE 12-16 enforced",
    "role": "ChatGPT = Design/Advisory only (no execution)",
    "handover_required": true,
    "n8n_instance": "http://192.168.50.246:5678"
  },
  "current_goal": "...",
  "active_projects": [...],
  "tool_status": {...},
  "last_updated": "2026-01-09T...",
  "status": "success"
}
```

### Test Rules Endpoint

```powershell
curl http://192.168.50.246:5678/webhook/chatgpt-rules
```

**Expected Response:**
```json
{
  "rules_summary": {
    "rule_12": "Strict role separation...",
    "rule_13": "Mandatory handover protocol...",
    "rule_14": "No self-initiated execution...",
    "rule_15": "Automatic task routing...",
    "rule_16": "Error analysis & resolution protocol..."
  },
  "roles": {
    "chatgpt": "Design/Advisory only - NEVER execute commands",
    "warp": "Execution only - NEVER redesign",
    "github": "Source of truth for all governance"
  },
  "n8n_instance": "http://192.168.50.246:5678",
  "last_updated": "2026-01-09T..."
}
```

---

## Workflow Architecture

### ChatGPT Context Provider

```
Webhook (GET /chatgpt-context)
  ↓
Fetch Memory Service (HTTP Request to localhost:8765/api/memory)
  ↓ (success)
Format Response (Code node)
  ↓
Respond to Webhook (JSON)

  ↓ (error)
Error Handler (Code node)
  ↓
Respond Error (JSON)
```

### ChatGPT Rules Provider

```
Webhook (GET /chatgpt-rules)
  ↓
Read Rules File (Read Binary File)
  ↓ (success)
Parse Rules (Code node)
  ↓
Respond to Webhook (JSON)

  ↓ (error)
Fallback Rules (Code node with cached summary)
  ↓
Respond Fallback (JSON)
```

---

## Error Handling

Both workflows include error handling:

### Context Provider
- **Success**: Returns full memory data
- **Error**: Returns degraded mode with basic governance info

### Rules Provider  
- **Success**: Returns parsed rules from file
- **Error**: Returns fallback cached rules summary

This ensures ChatGPT always receives a response, even if services are down.

---

## Maintenance

### Update Endpoints

If memory service URL changes, update in `chatgpt-context-provider`:
1. Open workflow
2. Edit **"Fetch Memory Service"** node
3. Update `url` parameter
4. Save and re-activate

### Update Rules File Path

If GLOBAL_AI_RULES.md moves, update in `chatgpt-rules-provider`:
1. Open workflow
2. Edit **"Read Rules File"** node  
3. Update `filePath` parameter
4. Save and re-activate

---

## Security Considerations

### Current Setup (Development)
- ✅ Webhooks are publicly accessible
- ✅ No authentication required
- ⚠️ Suitable for local/internal network only

### Production Setup (Recommended)

Add authentication to webhooks:

1. **Option A: Query Parameter Token**
   ```javascript
   // In webhook trigger node, add condition:
   if ($webhookQuery.key !== 'YOUR_SECRET_TOKEN') {
     return { error: 'Unauthorized' };
   }
   ```
   
   URL becomes: `http://192.168.50.246:5678/webhook/chatgpt-context?key=YOUR_SECRET_TOKEN`

2. **Option B: Header-Based Auth**
   ```javascript
   // In Code node before processing:
   const auth = $node["Webhook"].json.headers.authorization;
   if (auth !== 'Bearer YOUR_SECRET_TOKEN') {
     $respond({
       status: 401,
       body: { error: 'Unauthorized' }
     });
   }
   ```

3. **Option C: IP Whitelist**
   - Configure n8n firewall rules
   - Restrict webhook access to specific IPs

---

## Troubleshooting

### Webhook Not Found (404)
- Verify workflow is **activated**
- Check webhook path in n8n UI
- Ensure n8n is running

### Memory Service Timeout
- Check Memory Service: `curl http://localhost:8765/api/memory`
- Verify service is running
- Check firewall rules

### Rules File Not Found
- Verify file exists: `Test-Path "C:\Users\bermi\Projects\ai-governance\GLOBAL_AI_RULES.md"`
- Check n8n has file system permissions
- Use fallback mode if needed

### Empty Response
- Check n8n execution logs
- Test each node individually
- Verify JSON structure in Code nodes

---

## Next Steps

1. ✅ Import workflows to n8n
2. ✅ Activate both workflows
3. ✅ Test endpoints with curl
4. ✅ Update ChatGPT Custom Instructions with webhook URLs
5. ✅ Test in new ChatGPT conversation

---

## Related Documents

- Custom Instructions: `blueprints/CHATGPT_CUSTOM_INSTRUCTIONS.txt`
- Process Blueprint: `blueprints/CHATGPT_AUTOLOAD_PROCESS.md`
- Governance Rules: `GLOBAL_AI_RULES.md`

---

**Status:** Ready for deployment  
**Estimated Setup Time:** 10 minutes

---

**Co-Authored-By: Warp <agent@warp.dev>**
