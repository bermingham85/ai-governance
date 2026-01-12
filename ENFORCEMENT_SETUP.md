# GOVERNANCE ENFORCEMENT SETUP
**Making AI Governance Automatic and Self-Enforcing**

**Version:** 1.0.0  
**Last Updated:** 2026-01-12  
**Setup Time:** ~10 minutes  

---

## 🎯 GOAL

Make the governance framework **automatically enforced** so:
- ✅ Warp loads rules on every startup
- ✅ Pre-flight checks run before new projects
- ✅ Duplicate repos are prevented
- ✅ Decision matrix is mandatory
- ✅ Compliance is validated automatically

---

## 📋 SETUP CHECKLIST

### ☐ Step 1: Configure Warp Global Rules (2 minutes)

1. **Open Warp**
2. **Go to:** Settings → Rules → Global Rules
3. **Add this rule:**

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

4. **Save the rule**

---

### ☐ Step 2: Setup PowerShell Profile (3 minutes)

1. **Open PowerShell profile:**
   ```powershell
   notepad $PROFILE
   ```
   
   *If file doesn't exist:*
   ```powershell
   New-Item -Path $PROFILE -Type File -Force
   notepad $PROFILE
   ```

2. **Add this content** (copy from `scripts/profile-snippet.ps1`):
   ```powershell
   # AI Governance Auto-Load
   $env:WARP_GOVERNANCE = "C:\Users\bermi\Projects\ai-governance\GLOBAL_AI_RULES.md"
   $env:PROJECT_REGISTRY = "C:\Users\bermi\Projects\PROJECT_REGISTRY.md"
   $env:DECISION_MATRIX = "C:\Users\bermi\Projects\ai-governance\guides\PROJECT_DECISION_MATRIX.md"

   # Show governance banner on startup
   . "C:\Users\bermi\Projects\ai-governance\scripts\profile-snippet.ps1"
   ```

3. **Save and close**

4. **Reload profile:**
   ```powershell
   . $PROFILE
   ```

You should see a governance banner appear!

---

### ☐ Step 3: Create Convenient Aliases (Already Done!)

The profile snippet creates these aliases:

| Alias | Command | Purpose |
|-------|---------|---------|
| `pgov` | `Check-Governance` | Run pre-flight check |
| `sreg` | `Search-Registry` | Search project registry |
| `matrix` | `Show-DecisionMatrix` | Open decision matrix |
| `newproj` | `New-ProjectDecision` | Interactive wizard |

**Test them:**
```powershell
pgov                           # Run basic check
sreg agent                     # Search for "agent" in registry
matrix                         # Open decision matrix
newproj -ProjectName "my-api"  # Start decision wizard
```

---

### ☐ Step 4: Test Pre-Flight Check (2 minutes)

**Test without project:**
```powershell
C:\Users\bermi\Projects\ai-governance\scripts\pre-flight-check.ps1
```

**Test with new project:**
```powershell
C:\Users\bermi\Projects\ai-governance\scripts\pre-flight-check.ps1 -NewProject -ProjectName "test-api"
```

**Expected output:**
- ✓ All governance files found
- ✓ Searches registry for duplicates
- ✓ Checks git configuration
- ✓ Validates environment

---

### ☐ Step 5: Verify Warp Rule Loading (1 minute)

1. **Restart Warp** (to load new rules)
2. **Ask Warp:** 
   ```
   What governance rules must you follow?
   ```
3. **Expected response:** Should mention GLOBAL_AI_RULES, PROJECT_DECISION_MATRIX, and PROJECT_REGISTRY

4. **Ask Warp:**
   ```
   I want to create a new agent system. What should you do first?
   ```
5. **Expected response:** Should say it needs to:
   - Search PROJECT_REGISTRY.md
   - Check for existing agent systems (agent-agency-mcp, etc.)
   - Run PROJECT_DECISION_MATRIX
   - NOT just start building

---

### ☐ Step 6: Create ADR Directory (30 seconds)

```powershell
mkdir C:\Users\bermi\Projects\ai-governance\adr -Force
```

This is where Architecture Decision Records will be stored.

---

## ✅ VERIFICATION

### Test 1: PowerShell Profile
```powershell
# Close and reopen PowerShell
# You should see the governance banner

# Test environment variables
$env:WARP_GOVERNANCE
$env:PROJECT_REGISTRY
$env:DECISION_MATRIX

# All should show paths
```

### Test 2: Aliases Work
```powershell
pgov
# Should run pre-flight check

sreg orchestrator
# Should search and show results

Get-Alias pgov
# Should show alias definition
```

### Test 3: Warp Rules Active
Ask Warp these questions:
1. "What rules govern your operations?"
2. "Can I create a new repository without checking existing ones?"
3. "What's the PROJECT_DECISION_MATRIX?"

Warp should reference the governance documents.

### Test 4: Pre-Flight Check Works
```powershell
pgov -NewProject -ProjectName "duplicate-agent"
# Should warn about existing agent systems
```

---

## 🔄 ENFORCEMENT LAYERS

Once setup is complete, you have **3 enforcement layers**:

### Layer 1: Automatic (Warp)
- ✅ Rules loaded on every Warp session
- ✅ Warp self-enforces before taking action
- ✅ Warp references governance docs

### Layer 2: Manual (You)
- ✅ Run `pgov` before new projects
- ✅ Run `newproj` for decision wizard
- ✅ Check `sreg` for existing solutions

### Layer 3: Preventive (Scripts)
- ✅ Pre-flight check validates compliance
- ✅ Searches for duplicates
- ✅ Requires decision matrix completion

---

## 🚀 DAILY USAGE

### When Starting New Project:

**Option A: Quick Check**
```powershell
pgov -NewProject -ProjectName "my-new-api"
```

**Option B: Interactive Wizard**
```powershell
newproj -ProjectName "my-new-api"
```

**Option C: Manual Process**
1. `sreg api` - Search registry
2. `matrix` - Open decision matrix
3. Follow 8-step process
4. Document in ADR
5. Create repo or extend existing

### When Working on Existing Project:
```powershell
pgov
# Just validates environment
```

### When Searching for Existing Solutions:
```powershell
sreg [keyword]
# Example: sreg agent
# Example: sreg automation
```

---

## 📊 SUCCESS METRICS

You'll know it's working when:

✅ **Warp mentions governance docs** when asked about rules  
✅ **PowerShell shows governance banner** on startup  
✅ **Aliases work:** `pgov`, `sreg`, `matrix`, `newproj`  
✅ **Pre-flight check passes** with all green checks  
✅ **No duplicate repos created** (verified quarterly)  
✅ **All decisions documented** in `adr/`  
✅ **PROJECT_REGISTRY stays updated** with new projects  

---

## 🔧 TROUBLESHOOTING

### Issue: PowerShell profile doesn't load

**Solution:**
```powershell
# Check execution policy
Get-ExecutionPolicy

# If Restricted, change to RemoteSigned
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Reload profile
. $PROFILE
```

### Issue: Warp doesn't mention governance rules

**Solution:**
1. Verify rule is saved in Warp Settings → Rules
2. Restart Warp completely
3. Test with: "What rules do you follow?"
4. If still not working, explicitly mention in each task:
   ```
   [Your task]
   
   Follow: C:\Users\bermi\Projects\ai-governance\GLOBAL_AI_RULES.md
   ```

### Issue: Pre-flight check fails

**Solution:**
```powershell
# Check if governance files exist
Test-Path C:\Users\bermi\Projects\ai-governance\GLOBAL_AI_RULES.md
Test-Path C:\Users\bermi\Projects\ai-governance\guides\PROJECT_DECISION_MATRIX.md
Test-Path C:\Users\bermi\Projects\PROJECT_REGISTRY.md

# If missing, pull from GitHub
cd C:\Users\bermi\Projects\ai-governance
git pull origin main
```

### Issue: Aliases not working

**Solution:**
```powershell
# Re-source profile
. $PROFILE

# Or manually load script
. C:\Users\bermi\Projects\ai-governance\scripts\profile-snippet.ps1

# Verify aliases exist
Get-Alias pgov, sreg, matrix, newproj
```

---

## 📝 NEXT STEPS AFTER SETUP

1. **Test the system** with a mock project:
   ```powershell
   newproj -ProjectName "test-project"
   ```

2. **Review existing projects** against the decision matrix:
   - Should any be merged?
   - Are there duplicates?

3. **Create first ADR** documenting the governance setup itself:
   ```markdown
   # ADR-001: AI Governance Framework Implementation
   
   Date: 2026-01-12
   Status: Accepted
   
   ## Context
   Need systematic approach to prevent duplicate repos and ensure quality.
   
   ## Decision
   Implement ai-governance framework with automatic enforcement.
   
   ...
   ```

4. **Schedule quarterly review** of:
   - Duplicate repo audit
   - Decision matrix effectiveness
   - Rule compliance rate

---

## 📚 REFERENCE

**Key Files:**
- Global Rules: `C:\Users\bermi\Projects\ai-governance\GLOBAL_AI_RULES.md`
- Decision Matrix: `C:\Users\bermi\Projects\ai-governance\guides\PROJECT_DECISION_MATRIX.md`
- Project Registry: `C:\Users\bermi\Projects\PROJECT_REGISTRY.md`
- Pre-Flight Check: `C:\Users\bermi\Projects\ai-governance\scripts\pre-flight-check.ps1`
- Profile Snippet: `C:\Users\bermi\Projects\ai-governance\scripts\profile-snippet.ps1`

**Commands:**
- `pgov` - Pre-flight governance check
- `sreg [keyword]` - Search project registry
- `matrix` - Open decision matrix
- `newproj [name]` - New project wizard

---

**Setup Complete!** 🎉

Your AI governance framework is now automatically enforced.

**Next:** Create Phase 1 remaining guides (DEFINITION_OF_DONE, HANDOVER_PROTOCOL)

---

**Document Owner:** Primary System Administrator  
**Last Updated:** 2026-01-12  
**Setup Status:** ✅ Ready to Execute  

**Co-Authored-By: Warp <agent@warp.dev>**
