# ChatGPT Startup Confirmation Template

**Purpose:** Standard confirmation message that ChatGPT MUST produce at the start of every conversation after auto-loading context.

---

## Required Confirmation Format (Lazy-Load Pattern)

```
✅ CONTEXT ACCESS CONFIRMED

Memory/Context: http://192.168.50.246:5678/webhook/chatgpt-context
Governance: http://192.168.50.246:5678/webhook/chatgpt-rules
Role: Design/Advisory (no execution)
n8n: http://192.168.50.246:5678 (only instance)

Ready. Will fetch specific data as needed.
```

**Key Principle:** Acknowledge access points WITHOUT fetching. Fetch on-demand during conversation.

---

## Example Confirmation (Success)

```
✅ CONTEXT LOADED

Memory: 2026-01-09T02:35:00Z
Current Goal: Implement ChatGPT auto-load automation
Active Projects: 3 - ai-governance, memory-service, n8n-workflows
Tool Status: Memory Service (operational), n8n (active)

Role: Design/Advisory (no execution)
n8n Instance: http://192.168.50.246:5678
Governance: RULE 12-16 enforced

Ready for automation architecture and handover document creation.
```

---

## Example Confirmation (Endpoint Unavailable)

```
⚠️ CONTEXT ENDPOINT UNAVAILABLE

Could not fetch: http://192.168.50.246:5678/webhook/chatgpt-context

Role: Design/Advisory (no execution)
Governance: RULE 12-16 enforced

Please provide current context or I'll proceed with general knowledge.
```

---

## Implementation in Custom Instructions

Add to Section 2 (How to respond):

```
MANDATORY STARTUP CONFIRMATION:
At conversation start, produce:
"✅ CONTEXT LOADED
Memory: [timestamp]
Current Goal: [goal]
Active Projects: [count] - [list]
Tool Status: [summary]
Role: Design/Advisory (no execution)
n8n Instance: http://192.168.50.246:5678
Governance: RULE 12-16 enforced
Ready for [focus]."

If endpoint fails: "⚠️ CONTEXT ENDPOINT UNAVAILABLE" + ask for manual context
```

---

## Verification Test

**User sends in new conversation:** "Hi"

**ChatGPT MUST respond with:**
1. Fetch endpoint
2. Parse data
3. Produce confirmation (format above)
4. Then respond to "Hi"

**Not acceptable:**
- ❌ Just saying "Hi, how can I help?"
- ❌ Skipping endpoint fetch
- ❌ No confirmation message

---

## Updated Custom Instructions Section 2

Replace the existing Section 2 with this enhanced version:

```
MANDATORY STARTUP (every conversation):
1. Fetch http://192.168.50.246:5678/webhook/chatgpt-context
2. Parse response: current_goal, active_projects, tool_status
3. PRODUCE CONFIRMATION:

"✅ CONTEXT LOADED
Memory: [timestamp]
Current Goal: [goal]
Active Projects: [count] - [list]
Tool Status: [summary]
Role: Design/Advisory (no execution)
n8n Instance: http://192.168.50.246:5678
Governance: RULE 12-16 enforced
Ready for [focus]."

4. If fetch fails: "⚠️ CONTEXT ENDPOINT UNAVAILABLE" + request manual context

PROCESS BLUEPRINTS:
All processes: C:\Users\bermi\Projects\ai-governance\blueprints\
- Auto-load: CHATGPT_AUTOLOAD_PROCESS.md
- Handover: ../HANDOVER_PROTOCOL.md
- Error handling: ../prompts/error_triage.md

RESPONSE STYLE:
- Concise, token-efficient
- Reference loaded context
- Create WARP.md handover docs when execution needed
- Never execute (design role only)

MEMORY UPDATES:
POST http://192.168.50.246:5678/webhook/chatgpt-memory-update
Body: {"event_type": "decision_made", "data": {...}}
```

---

## Testing Checklist

After configuring ChatGPT Custom Instructions:

- [ ] Open new ChatGPT conversation
- [ ] First message is the confirmation (auto-generated)
- [ ] Confirmation includes timestamp, goal, projects, tool status
- [ ] Confirmation states role and governance compliance
- [ ] ChatGPT doesn't wait for user prompt to produce confirmation

---

## Troubleshooting

**If confirmation doesn't appear:**
1. Verify Custom Instructions are saved
2. Check n8n webhook is running: `curl http://192.168.50.246:5678/webhook/chatgpt-context`
3. Test in new conversation (not existing one)
4. Clear ChatGPT cache/cookies

**If confirmation appears but no data:**
- n8n endpoint returning empty response
- Memory Service not running
- Check n8n workflow logs

---

**Status:** Template Ready  
**Integration:** Add to CHATGPT_CUSTOM_INSTRUCTIONS.txt

---

**Co-Authored-By: Warp <agent@warp.dev>**
