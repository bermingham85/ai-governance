HANDOVER TO: Claude

TASK TYPE: Design

SOURCE OF TRUTH:
- Repo(s): ai-governance, orchestrator
- Branch: main
- Rules referenced: GLOBAL_AI_RULES.md (RULE 12-16), HANDOVER_PROTOCOL.md

GOAL:
Design a complete activation and monitoring system for the autonomous workflows, including n8n webhook setup, monitoring dashboards, and validation that the system is actively working.

CONSTRAINTS:
- GitHub is source of truth
- Follow GLOBAL_AI_RULES.md (RULE 12-16)
- Protected zones are off-limits
- No secrets in commits
- Claude designs, Warp executes
- Fix errors, do not bypass

CONTEXT:
Warp has completed project governance setup:
- 41 projects now have WARP.md, ERROR_LOG.md, Dockerfile
- 39 projects committed with proper attribution
- n8n workflows created but NOT deployed
- Templates ready in ai-governance/templates/
- Automation layer (Phase 3) is designed but inactive

USER ISSUE:
User wants to know:
1. How to TRIGGER/ACTIVATE the autonomous system
2. How to MONITOR that it's actively working
3. How to SEE actual improvements happening

CURRENT STATE:
✅ Foundation complete (governance files in all projects)
✅ Docker templates created
✅ n8n workflows designed
❌ Workflows NOT imported to n8n
❌ No active monitoring
❌ No visible autonomous operations yet

REQUIRED DESIGN:
1. **Activation System Design**
   - Step-by-step n8n workflow deployment
   - Webhook endpoint specifications
   - Required credentials/configuration
   - Validation tests

2. **Monitoring System Design**
   - Real-time dashboard
   - Health indicators
   - Progress metrics
   - Alert system

3. **Visibility System Design**
   - How to see auto-commits
   - How to track improvements
   - How to verify autonomous operations
   - Performance metrics

4. **WARP.md Handover Document**
   - Exact commands for Warp to execute
   - Webhook creation steps
   - n8n workflow import procedure
   - Monitoring script deployment
   - Validation checklist

EXECUTION STEPS FOR WARP:
[Claude to design these steps]

STOP CONDITION:
STOP after creating complete design with WARP.md handover document for activation system deployment.

---

**Current violation:** Warp designed the activation guide (RULE 12 violation)
**Correction needed:** Claude designs, then hands to Warp for execution

---

**Waiting for Claude's design...**
