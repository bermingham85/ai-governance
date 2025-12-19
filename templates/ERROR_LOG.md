# Error Log

**Project:** [Project Name]  
**Purpose:** Track resolved errors to prevent rediscovery  
**Governance:** RULE 16 (Error Analysis & Resolution Protocol)

---

## How to Use This Log

**When to add entries:**
- Any error that took >2 attempts to resolve
- Errors that required escalation
- Errors with non-obvious solutions
- External API / dependency changes
- Architectural issues

**What NOT to log:**
- Simple typos (fixed immediately)
- Obvious mistakes (missed semicolon)
- First-time learning (normal development)

**Format:**
```md
### [YYYY-MM-DD] Error: [Brief Title]

**Type:** [A/B/C/D/E per RULE 16]
**Root Cause:** [1-2 sentences]
**Fix Applied:** [1-2 sentences]
**Resolved By:** [Warp / Claude / Research]
**Tokens Used:** [rough estimate]
**Prevention:** [how to avoid in future]
```

---

## Error Entries

<!-- Add error entries below in reverse chronological order (newest first) -->

### [2025-12-19] Example: Build fails after dependency update

**Type:** A (Build / Runtime)
**Root Cause:** New version of @types/node incompatible with TypeScript 4.x
**Fix Applied:** Pinned @types/node to 18.x in package.json, updated tsconfig compilerOptions
**Resolved By:** Warp (2 attempts, escalated to docs research)
**Tokens Used:** ~500
**Prevention:** Lock dependency versions in package.json, test updates in isolation

---

### [2025-12-19] Example: Claude bridge returns 401

**Type:** D (Tool / Integration)
**Root Cause:** Anthropic API key not configured in n8n credentials vault
**Fix Applied:** Added HTTP Header Auth credential named "Anthropic API Key" in n8n Settings
**Resolved By:** Warp (diagnostics) + manual n8n configuration
**Tokens Used:** ~200
**Prevention:** Document credential requirements in SECRETS_REGISTRY.md

---

### [2025-12-19] Example: Data not saving to database

**Type:** B (Logic / Architecture)
**Root Cause:** Missing await on async database call, code continued before insert completed
**Fix Applied:** Added await to db.registerAgent() call, verified with tests
**Resolved By:** Claude (architectural review) → Warp (execution)
**Tokens Used:** ~800
**Prevention:** Enforce async/await linting rules, add integration tests

---

<!-- Add new entries above this line -->

---

## Statistics

**Total Errors Logged:** [count]  
**Most Common Type:** [A/B/C/D/E]  
**Average Resolution Time:** [estimate]  
**Token Efficiency:** [before/after RULE 16]

---

**Template Version:** 1.0.0  
**Last Updated:** [YYYY-MM-DD]

---

**Co-Authored-By: Warp <agent@warp.dev>**
