# ChatGPT Auto-Load Process Blueprint

**Version:** 1.0.0  
**Last Updated:** 2026-01-09  
**Purpose:** Automate context loading for ChatGPT at conversation start  
**Authority:** ai-governance repository

---

## Problem Statement

ChatGPT needs to auto-load memory, context, and governance rules at the start of every conversation without manual prompting to:
- Reduce token waste
- Maintain consistency across sessions
- Access latest project state
- Follow governance protocols

---

## Architecture

```
ChatGPT (cloud) 
    ↓ [HTTP GET at conversation start]
n8n Webhook (http://192.168.50.246:5678/webhook/chatgpt-context)
    ↓ [fetches data]
Memory Service API (http://localhost:8765/api/memory)
    ↓ [reads]
memory.json (C:\Users\bermi\.ai_context\memory.json)
```

---

## Implementation Steps

### 1. Create n8n Context Aggregator Workflow

**Workflow Name:** `chatgpt-context-provider`  
**Trigger:** Webhook `GET /webhook/chatgpt-context`  
**Response Format:** JSON

**Nodes:**
1. **Webhook Trigger** (GET)
   - Path: `/webhook/chatgpt-context`
   - Response Mode: Last Node

2. **HTTP Request: Memory Service**
   - Method: GET
   - URL: `http://localhost:8765/api/memory`
   - Authentication: None

3. **HTTP Request: Governance Rules**
   - Method: GET  
   - URL: `https://raw.githubusercontent.com/[your-username]/ai-governance/main/GLOBAL_AI_RULES.md`
   - Authentication: None
   - _Note: Replace with actual GitHub raw URL_

4. **Function: Format Response**
   ```javascript
   return {
     json: {
       memory: $node["HTTP Request: Memory Service"].json.data,
       governance_summary: {
         rules: "RULE 12-16 enforced",
         role: "ChatGPT = Design/Advisory only (no execution)",
         handover_required: true,
         n8n_instance: "http://192.168.50.246:5678"
       },
       current_goal: $node["HTTP Request: Memory Service"].json.data.current_goal || "No active goal",
       active_projects: $node["HTTP Request: Memory Service"].json.data.active_projects || [],
       tool_status: $node["HTTP Request: Memory Service"].json.data.tool_status || {},
       last_updated: new Date().toISOString()
     }
   };
   ```

5. **Respond to Webhook**
   - Return formatted JSON

**Workflow JSON:** Save to `C:\Users\bermi\Projects\ai-governance\n8n-workflows\chatgpt-context-provider.json`

---

### 2. Alternative: Simple File Server (if Memory Service not running)

**Option A: Python HTTP Server**
```powershell
# In C:\Users\bermi\.ai_context\
python -m http.server 8766
```
Access at: `http://192.168.50.246:8766/memory.json`

**Option B: n8n File Reader**
- Use "Read Binary File" node
- Path: `C:\Users\bermi\.ai_context\memory.json`
- Return as JSON response

---

### 3. ChatGPT Custom Instructions

**What would you like ChatGPT to know about you?**

```
Developer managing multi-AI system with strict governance.

AUTO-LOAD ENDPOINT (fetch at every conversation start):
http://192.168.50.246:5678/webhook/chatgpt-context

This endpoint returns:
- Current memory/context
- Active projects and goals
- Tool status
- Governance rules summary

SYSTEM ROLES:
- ChatGPT: Design/advisory (no execution)
- Warp: Execution only
- n8n: http://192.168.50.246:5678 (only instance)

REFERENCE DOCS:
- Governance: https://github.com/[username]/ai-governance
- Process blueprints: /blueprints/ directory
```

**How would you like ChatGPT to respond?**

```
STARTUP ROUTINE:
1. Fetch http://192.168.50.246:5678/webhook/chatgpt-context
2. Parse current_goal, active_projects, tool_status
3. Acknowledge: "Context loaded. Current focus: [goal]"
4. If fetch fails, acknowledge and ask user for context

RESPONSE RULES:
- Concise, token-efficient
- Reference loaded context
- Never execute commands (design role only)
- Create handover docs for Warp when execution needed
- Update memory via n8n webhooks when decisions made

MEMORY UPDATE PATTERN:
POST http://192.168.50.246:5678/webhook/chatgpt-memory-update
Body: {"event_type": "decision_made", "data": {...}}
```

---

## Process Flow Diagram

```
┌─────────────────────────────────────┐
│ User Opens ChatGPT Conversation     │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ Custom Instructions Auto-Execute    │
│ "Fetch context endpoint..."         │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ GET /webhook/chatgpt-context        │
│ (n8n workflow triggered)            │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ n8n fetches:                        │
│ - Memory Service API                │
│ - Governance rules                  │
│ - Active projects                   │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ n8n returns aggregated JSON         │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ ChatGPT parses response             │
│ "Context loaded. Ready."            │
└─────────────────────────────────────┘
```

---

## Security Considerations

**Public Exposure Risk:**
- n8n webhook is accessible over network
- Memory data exposed via HTTP

**Mitigation:**
1. **API Key Authentication**
   - Add query param: `?key={{API_KEY}}`
   - Validate in n8n workflow

2. **IP Whitelist** (n8n settings)
   - Restrict to trusted IPs only

3. **Data Filtering**
   - Don't expose secrets or sensitive paths
   - Return only summary data

**Implementation:**
```javascript
// n8n Function node - API Key Check
if ($json.query.key !== '{{API_KEY}}') {
  return { 
    json: { error: 'Unauthorized', status: 401 } 
  };
}
// ... rest of logic
```

---

## Maintenance

**When to Update:**
- Memory structure changes → Update n8n format function
- New governance rules → No change needed (auto-fetched)
- New projects → No change needed (from memory.json)

**Testing:**
```powershell
# Test n8n endpoint
curl http://192.168.50.246:5678/webhook/chatgpt-context

# Expected response
{
  "memory": {...},
  "governance_summary": {...},
  "current_goal": "...",
  "active_projects": [...],
  "tool_status": {...}
}
```

---

## Limitations

**ChatGPT Constraints:**
- Cannot access local file system
- Cannot use MCP servers directly
- Requires public HTTP endpoint
- Custom instructions have token limits

**Workarounds:**
- Use n8n as public gateway
- Keep custom instructions concise (link to docs)
- Cache context in conversation (update as needed)

---

## Alternative: GitHub-Hosted Context

**If n8n endpoint not feasible:**

1. **Auto-commit context to GitHub**
   - n8n workflow: Every hour, commit memory.json to repo
   - Path: `ai-governance/context/current_context.json`

2. **ChatGPT fetches from GitHub Raw URL**
   ```
   https://raw.githubusercontent.com/[user]/ai-governance/main/context/current_context.json
   ```

3. **Pro:** No server needed, always available  
   **Con:** Max 1-hour staleness

---

## Integration with Existing Rules

**Compliance:**
- ✅ RULE 12: ChatGPT stays in design role (no execution)
- ✅ RULE 13: Uses handover protocol to Warp
- ✅ RULE 15: Automatic task routing
- ✅ n8n instance: http://192.168.50.246:5678 (only instance)

**Handover Pattern:**
When ChatGPT needs execution:
1. Create WARP.md handover document
2. User copies to Warp
3. Warp executes and reports back
4. ChatGPT reviews results

---

## Next Steps

1. **Create n8n workflow** (see Step 1 above)
2. **Test endpoint** with curl
3. **Update ChatGPT Custom Instructions** (see Step 3 above)
4. **Verify auto-load** in new ChatGPT conversation
5. **Document workflow JSON** in ai-governance/n8n-workflows/

---

## Related Documents

- **Governance:** `GLOBAL_AI_RULES.md`
- **Handover Protocol:** `HANDOVER_PROTOCOL.md`
- **Memory Service:** `memory-service/README.md`
- **n8n Workflows:** `n8n-workflows/` (to be created)

---

**Status:** Blueprint Ready  
**Implementation Time:** 30 minutes  
**Maintenance:** Low (auto-updates from memory)

---

**Co-Authored-By: Warp <agent@warp.dev>**
