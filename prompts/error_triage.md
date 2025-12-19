# Error Triage - Warp Prompt

**Purpose:** When something fails, use this prompt to classify and route the error efficiently.  
**Governance:** RULE 16 (Error Analysis & Resolution Protocol)

---

## Usage

When you encounter an error, paste this prompt:

```
ERROR DETECTED

Error Type: [describe what failed]
Error Message: [exact error output]
Context: [what you were doing when it failed]
Attempts So Far: [0/1/2]

TRIAGE REQUIRED:
1. Classify this error (A-E per RULE 16)
2. Route to correct platform
3. Suggest fix approach or escalation
4. Record outcome when resolved

Follow GLOBAL_AI_RULES.md RULE 16 strictly.
```

---

## Classification Quick Reference

**A) Build / Runtime** - compilation, dependencies, package errors
**B) Logic / Architecture** - data flow, design conflicts, boundaries
**C) UI / UX** - layouts, flows, visual issues
**D) Tool / Integration** - APIs, MCP, n8n, database
**E) Knowledge / Unknown** - missing docs, unclear behaviour

---

## Routing Decision Tree

### If classified as A (Build / Runtime):
```
Warp tries 1-2 fixes using logs
├─ Fixed? → Document in commit message, done
└─ Still failing after 2 attempts?
   → Escalate to Claude with full error logs
   → Claude analyzes architecture
   → Returns fix plan to Warp
```

### If classified as B (Logic / Architecture):
```
STOP immediately
→ Hand error details to Claude
→ Claude performs root cause analysis
→ Claude creates fix plan
→ Warp executes fix plan
```

### If classified as C (UI / UX):
```
STOP immediately
→ Hand to design AI (Emergent or Claude)
→ Design AI provides corrected layout/flow
→ Warp applies diffs
```

### If classified as D (Tool / Integration):
```
Warp diagnoses (check connectivity, auth, versions)
├─ Simple fix (credentials, endpoint)? → Apply and test
└─ Complex root cause?
   → Escalate to Claude for reasoning
   → Research if external API change
   → Apply fix with documentation
```

### If classified as E (Knowledge / Unknown):
```
Warp or Claude performs research:
→ Check official docs
→ Search for API changes
→ Review recent GitHub issues
→ Web search for similar errors

Once understood:
→ Document findings in governance
→ Apply fix
→ Record in ERROR_LOG.md
```

---

## Attempt Tracking

**Track your attempts:**

```
Attempt 1: [what you tried] → [result]
Attempt 2: [what you tried] → [result]
Attempt 3: STOP - ESCALATE PER RULE 16
```

**After 2 failed attempts WITHOUT new information:**
- STOP
- Classify error
- Route to correct platform
- Record what you learned

---

## Error Recording Template

When error is resolved, add to `docs/ERROR_LOG.md`:

```md
### [YYYY-MM-DD] Error: [Brief Title]

**Type:** [A/B/C/D/E]
**Root Cause:** [1-2 sentences]
**Fix Applied:** [1-2 sentences]
**Resolved By:** [Warp / Claude / Research]
**Tokens Used:** [estimate]
**Prevention:** [how to avoid in future]
```

---

## Anti-Patterns (DO NOT DO)

❌ Try 5 different fixes hoping something works
❌ "Let me just rewrite this from scratch"
❌ Skip classification and guess
❌ Assume you know the fix without verification
❌ Continue past 2 attempts without new info

---

## Example Triage

### Example 1: TypeScript Build Fails

```
ERROR DETECTED
Type: Compilation error in src/index.ts
Message: "Cannot find module '@types/node'"
Context: Running npm run build
Attempts: 0

CLASSIFICATION: A (Build / Runtime)
ROUTE: Warp (1-2 attempts max)

Attempt 1: npm install @types/node → SUCCESS
Documented in commit message.
```

### Example 2: Data Flow Seems Wrong

```
ERROR DETECTED
Type: User data not reaching dashboard
Message: No explicit error, but behaviour incorrect
Context: Testing new feature
Attempts: 0

CLASSIFICATION: B (Logic / Architecture)
ROUTE: Claude (immediate escalation)

STOP - Handing to Claude with:
- Expected behaviour
- Actual behaviour
- Data flow diagram
- Recent changes

Awaiting Claude's architectural analysis.
```

### Example 3: Unknown API Error Code

```
ERROR DETECTED
Type: API returns 422 with unclear message
Message: "Validation failed" (no details)
Context: POST request to /api/agents
Attempts: 1 (checked auth, checked payload format)

CLASSIFICATION: E (Knowledge / Unknown)
ROUTE: Research

Research steps:
1. Check API docs for 422 error codes
2. Search GitHub issues for similar errors
3. Test with minimal payload
4. Document findings

[After research]
RESOLUTION: API requires new 'version' field as of 2025-12-15
FIX: Added version: "1.0.0" to payload
RECORD: Updated SECRETS_REGISTRY.md with API changes
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-12-19 | Initial error triage prompt |

---

**Compliance:** RULE 16 (Error Analysis & Resolution Protocol)  
**Source:** ai-governance/prompts/error_triage.md

---

**Co-Authored-By: Warp <agent@warp.dev>**
