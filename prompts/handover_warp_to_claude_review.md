# HANDOVER: Execution to Review (Warp → Claude)

**Template Version:** 1.0.0  
**Governance:** RULE 13 (Mandatory Handover Protocol)  
**Usage:** Warp uses this template for all review handovers to Claude

---

## Template

```
═══════════════════════════════════════════════════════════════
                    HANDOVER TO: Claude
═══════════════════════════════════════════════════════════════

TASK TYPE: Review

SOURCE OF TRUTH:
- GitHub repo(s): <list repositories>
- Branch: <branch name>
- Rules: GLOBAL_AI_RULES.md, <other relevant rules>

───────────────────────────────────────────────────────────────

INPUTS:
- Execution completed: <what was executed>
- Files created/modified: <list with paths>
- Commands run: <list of commands with exit codes>
- Commit hash(es): <if applicable>
- Errors/warnings: <if any>

───────────────────────────────────────────────────────────────

REVIEW GOAL:
<One clear sentence: what needs to be reviewed and why>

───────────────────────────────────────────────────────────────

REVIEW CHECKLIST:
- [ ] <First verification item>
- [ ] <Second verification item>
- [ ] <Continue with all items to check>

───────────────────────────────────────────────────────────────

NEXT STEPS:
<What should happen after review - leave decision to Claude>

───────────────────────────────────────────────────────────────
```

---

## Usage Guidelines

### When to Use

- Execution is complete (successful or with errors)
- Review or audit needed before proceeding
- Error encountered requiring design decision
- Checkpoint reached requiring approval
- Compliance verification needed

### Before Handover Checklist

Warp MUST verify:
- [ ] Execution summary is complete
- [ ] All relevant file paths included
- [ ] Command results documented
- [ ] Errors clearly explained (if any)
- [ ] Review goal is specific
- [ ] Checklist items are verifiable

---

## Common Patterns

**Pattern: Successful Completion Review**
```
INPUTS:
- Execution completed: Created 10 governance files
- Files created: <list>
- Commit hash: abc123def456
- No errors encountered

REVIEW GOAL:
Verify all governance files are complete and compliant with RULE 12-15.

REVIEW CHECKLIST:
- [ ] All required files present
- [ ] File contents match specifications
- [ ] No secrets in commits
- [ ] Commit message follows conventions
```

**Pattern: Error Handover**
```
INPUTS:
- Execution stopped at step 3
- Error: <error message>
- Exit code: 1
- Files modified before error: <list>

REVIEW GOAL:
Diagnose error and determine corrective action for step 3.

REVIEW CHECKLIST:
- [ ] Error root cause identified
- [ ] Is retry safe?
- [ ] Are modified files in consistent state?
- [ ] Should rollback be performed?
```

**Pattern: Checkpoint Review**
```
INPUTS:
- Phase 1 completed successfully
- Files created: <list>
- Verification: All steps passed
- Ready for Phase 2

REVIEW GOAL:
Verify Phase 1 output and approve proceeding to Phase 2.

REVIEW CHECKLIST:
- [ ] Phase 1 outputs correct
- [ ] Dependencies for Phase 2 satisfied
- [ ] No issues requiring attention
- [ ] Safe to proceed
```

---

## Examples

### Example 1: Successful Governance Setup

```
HANDOVER TO: Claude

TASK TYPE: Review

SOURCE OF TRUTH:
- GitHub repo(s): ai-governance
- Branch: main
- Rules: GLOBAL_AI_RULES.md, HANDOVER_PROTOCOL.md

INPUTS:
- Execution completed: Created ai-governance repository with full structure
- Files created:
  • README.md
  • .gitignore
  • GLOBAL_AI_RULES.md
  • HANDOVER_PROTOCOL.md
  • CAPABILITIES_MANIFEST.md
  • SECRETS_POLICY.md
  • SECRET_ROTATION_LOG.md
  • prompts/handover_claude_to_warp.md
  • prompts/task_router.md
  • prompts/handover_warp_to_claude_review.md
- Commands run:
  • git init (exit code 0)
  • git add . (exit code 0)
  • git commit -m "Initial governance framework" (exit code 0)
- Commit hash: 1a2b3c4d5e6f
- No errors or warnings

REVIEW GOAL:
Verify ai-governance repository is complete, compliant with RULE 12-15, and ready for use.

REVIEW CHECKLIST:
- [ ] All 10 required files created
- [ ] GLOBAL_AI_RULES.md contains RULE 12-15
- [ ] HANDOVER_PROTOCOL.md follows specification
- [ ] CAPABILITIES_MANIFEST.md has Claude/Warp boundaries
- [ ] SECRETS_POLICY.md has storage locations
- [ ] Prompts directory fully populated
- [ ] .gitignore protects secrets
- [ ] Commit message includes co-author
- [ ] No secrets in repository
- [ ] README explains usage

NEXT STEPS:
Determine if project-level updates needed or if governance framework is complete.
```

---

### Example 2: Error During Execution

```
HANDOVER TO: Claude

TASK TYPE: Review

SOURCE OF TRUTH:
- GitHub repo(s): CHAT_ANALYZER_MASTER
- Branch: main
- Rules: GLOBAL_AI_RULES.md

INPUTS:
- Execution stopped at step 4 of 6
- Error message: "fatal: remote origin already exists"
- Exit code: 128
- Commands run successfully before error:
  • Created PROJECT_RULES.md (success)
  • git add PROJECT_RULES.md (exit code 0)
  • git commit -m "Add PROJECT_RULES" (exit code 0)
- Failed command:
  • git remote add origin https://github.com/bermingham85/CHAT_ANALYZER_MASTER.git (exit code 128)
- Files modified: PROJECT_RULES.md (committed locally, not pushed)

REVIEW GOAL:
Resolve remote origin conflict and determine safe way to complete push to GitHub.

REVIEW CHECKLIST:
- [ ] Is existing remote correct?
- [ ] Should we use existing remote or reconfigure?
- [ ] Is commit in safe state?
- [ ] Can we proceed with push using existing remote?
- [ ] Do we need to revise handover steps?

NEXT STEPS:
Provide revised handover or guidance to complete push operation safely.
```

---

### Example 3: Compliance Audit

```
HANDOVER TO: Claude

TASK TYPE: Review

SOURCE OF TRUTH:
- GitHub repo(s): All 18 project repositories
- Branch: main
- Rules: GLOBAL_AI_RULES.md, SECRETS_POLICY.md

INPUTS:
- Execution completed: Scanned all repositories for .env files
- Scan results:
  • Total repositories scanned: 18
  • Repositories with .env files: 5
  • Repositories with uncommitted .env: 2
  • Repositories with .env in .gitignore: 5
  • Repositories missing .gitignore: 3
- Affected repositories with uncommitted .env:
  • C:\Users\bermi\Projects\midjourney-news-automation
  • C:\Users\bermi\Projects\openai-notion-mcp
- No errors encountered

REVIEW GOAL:
Audit secret handling compliance and determine corrective actions for non-compliant repositories.

REVIEW CHECKLIST:
- [ ] Are uncommitted .env files a security risk?
- [ ] Should .env files be added to .gitignore?
- [ ] Do any .env files contain production secrets?
- [ ] Are there repositories that need .gitignore created?
- [ ] What is the remediation plan?

NEXT STEPS:
Determine if secrets need rotation and create handover for remediation actions.
```

---

## Review Response Format

When Claude receives review handover, Claude SHOULD respond with:

```
REVIEW COMPLETE

STATUS: <Approved | Issues Found | Requires Revision>

FINDINGS:
- <Finding 1>
- <Finding 2>
- <Continue...>

COMPLIANCE:
- <Compliant | Non-compliant> with <rule>
- <Reasoning>

NEXT ACTION:
<What should happen next>

<If Issues Found or Requires Revision, include revised handover or guidance>
```

---

## Error Handling Patterns

### Pattern: Recoverable Error

```
INPUTS:
- Error at step X: <error>
- Error is recoverable: Yes
- Suggested retry action: <action>

REVIEW GOAL:
Confirm retry is safe and provide revised step X instructions.
```

### Pattern: Unrecoverable Error

```
INPUTS:
- Error at step X: <error>
- Error is unrecoverable: Yes
- Rollback needed: Yes/No
- State before error: <description>

REVIEW GOAL:
Determine if rollback needed and design alternative approach.
```

### Pattern: Ambiguous Situation

```
INPUTS:
- Situation: <description>
- Warp assessment: <what Warp thinks>
- Uncertainty: <what is unclear>

REVIEW GOAL:
Clarify ambiguous situation and provide guidance for how to proceed.
```

---

## Anti-Patterns to Avoid

### ❌ Incomplete Execution Report

```
INPUTS:
- Execution completed
- Some errors

REVIEW GOAL:
Check if it's okay
```

**Problem:** Too vague, no details for Claude to review

---

### ❌ No Review Checklist

```
INPUTS:
- Files created: X, Y, Z

REVIEW GOAL:
Review the files

<no checklist>
```

**Problem:** Unclear what to verify

---

### ❌ Asking Warp to Decide

```
INPUTS:
- Error encountered

REVIEW GOAL:
Tell me what to do next

NEXT STEPS:
Should I retry or give up?
```

**Problem:** Violates role separation — design decisions belong to Claude

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2025-12-18 | Initial template | Warp (execution) |

---

**Template Owner:** ai-governance repository  
**Compliance:** RULE 13 (Mandatory Handover Protocol)

---

**Co-Authored-By: Warp <agent@warp.dev>**
