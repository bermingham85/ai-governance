# Warp Auto-Load Configuration

**Purpose:** Ensure governance rules are loaded into every Warp session automatically  
**Status:** Ready for user configuration

---

## Setup Instructions

### Add to Warp Global Rules

1. Open Warp
2. Go to Settings → Rules → Global Rules
3. Add this rule:

```
Before every task, you MUST load and follow these governance documents:

1. GLOBAL_AI_RULES.md: C:\Users\bermi\Projects\ai-governance\GLOBAL_AI_RULES.md
   - Contains RULE 12-16 (role separation, error handling, handover protocols)
   - MANDATORY compliance

2. PROJECT_DECISION_MATRIX.md: C:\Users\bermi\Projects\ai-governance\guides\PROJECT_DECISION_MATRIX.md
   - REQUIRED before creating any new project/repo
   - Complete 8-step decision process
   - Default bias: EXTEND existing repos

3. PROJECT_REGISTRY.md: C:\Users\bermi\Projects\PROJECT_REGISTRY.md
   - Check existing 34+ repositories before building anything
   - Prevent duplicate functionality

For ANY new project idea:
- Search PROJECT_REGISTRY.md first
- Run PROJECT_DECISION_MATRIX steps 1-8
- Document decision in ADR
- Update registry after creation

Failing to check these documents before action is a CRITICAL violation.
```

### Alternative: Environment Variable

Add to PowerShell profile (`$PROFILE`):

```powershell
$env:WARP_GOVERNANCE = "C:\Users\bermi\Projects\ai-governance\GLOBAL_AI_RULES.md"

# Optional: Display reminder
Write-Host "[Governance] Rules loaded from $env:WARP_GOVERNANCE" -ForegroundColor Green
```

---

## What Gets Enforced Automatically

Once configured, every Warp session will:

1. **Load GLOBAL_AI_RULES.md at startup**
2. **Check rules before execution**
3. **Self-report violations**
4. **Suggest proper workflow**

---

## Verification

Test if rules are loaded:

```powershell
# In Warp, ask:
"Am I allowed to execute commands according to my role?"

# Expected response:
"Yes - I am Warp (execution role). According to RULE 12, I must execute
commands, run scripts, make Git commits, and handle file operations."
```

---

## Enforcement Layers Summary

### Layer 1: Technical (Hard Blocks)
- ✅ Git hooks block .env commits
- ✅ Git hooks require WARP.md
- ✅ Git hooks detect RULE 14 violations
- ✅ File system protects zones

### Layer 2: Automatic (Soft Enforcement)
- ✅ Warp auto-loads rules (this config)
- ✅ Rules injected into context
- ✅ AI self-compliance expected

### Layer 3: Audit (Detective)
- ✅ Compliance scripts detect violations
- ✅ Git history provides audit trail
- ✅ ERROR_LOG tracks patterns

---

## What If Rules Aren't Loaded?

**Symptoms:**
- Warp doesn't mention RULE 12-16
- No self-reported violations
- Doesn't reference governance docs

**Fix:**
1. Verify global rule is saved
2. Restart Warp
3. Test with verification query above
4. If still failing, manually reference in each task:

```
[Task description]

Reference: C:\Users\bermi\Projects\ai-governance\GLOBAL_AI_RULES.md
Follow RULE 12-16 strictly.
```

---

## Next Steps

1. Add global rule to Warp (see Setup Instructions above)
2. Test with verification query
3. Confirm Git hooks are working (try committing a .env file)
4. Review ENFORCEMENT_STATUS.md for full picture

---

**Created:** 2026-01-07  
**Status:** Configuration required (5 minutes)

---

**Co-Authored-By: Warp <agent@warp.dev>**
