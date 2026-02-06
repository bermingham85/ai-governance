# WARP.md — Automation Build Template

**Use this template when:** Creating scripts, automation rules, or index systems that will run automatically.

---

## HANDOVER TO WARP

### Goal
[One sentence: What automation is being created and why]

### Constraints
- Follow GLOBAL_AI_RULES.md (Rules 12-16)
- Stay within authorized scope: `C:\Users\bermi\Projects\` and `.warp\`
- Use services before token burn (SERVICES_BEFORE_TOKENS rule)
- Maximum 2 fix attempts per error before escalation
- All commits must include `Co-Authored-By: Warp <agent@warp.dev>`

### Execution Steps

1. **Create Script**
   - Location: `C:\Users\bermi\Projects\_scripts\[script_name].py`
   - Include docstring, error handling, CLI arguments
   - Expected output: [describe]

2. **Create Trigger Rule**
   - Location: `.warp\rules\[RULE_NAME].md`
   - Define when automation should run
   - Include quick-command examples

3. **Test Automation**
   - Run script manually
   - Verify output matches expectations
   - Fix errors (max 2 attempts, then escalate)

4. **Version Control**
   - Initialize git repo if needed
   - Commit with descriptive message
   - Push to GitHub (create repo if needed)

5. **Update Indexes**
   - Run `python C:\Users\bermi\Projects\_scripts\index_updater.py`
   - Verify indexes reflect new resources

### Stop Conditions
- Stop if accessing protected zones (Photos, Personal, Fillmore/Filmora)
- Stop if error persists after 2 fix attempts
- Stop if requires architectural redesign (escalate to Claude)

### Success Criteria
- [ ] Script runs without errors
- [ ] Rule created with clear trigger conditions
- [ ] All changes committed and pushed to GitHub
- [ ] Indexes updated to reflect new resources

### Verification
After completion, confirm:
1. Script executes successfully with expected output
2. GitHub repos are in sync
3. No protected zones were accessed
4. Co-author attribution on all commits

---

**Template Version:** 1.0.0
**Created:** 2026-02-06
**For:** Automation builds requiring script + rule + git operations
