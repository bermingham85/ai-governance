# HANDOVER_PROTOCOL.md

**Version:** 1.0.0  
**Last Updated:** 2025-12-18  
**Status:** Mandatory  
**Governance Rule:** Implements RULE 13 (Mandatory Handover)

---

## Purpose

This document defines the standard format for all handovers between AI systems. This format is **non-optional** and must be followed for every handover.

**Key Principle:** Handovers prevent ambiguity, interpretation drift, and creative execution.

---

## Standard Handover Format

Every handover MUST follow this structure:

```
HANDOVER TO: <Warp | Claude | GitHub>

TASK TYPE: <Execution | Review | Design>

SOURCE OF TRUTH:
- Repo(s): <list of repositories>
- Branch: <branch name>
- Rules referenced: <list of governance files>

GOAL:
<One clear sentence describing the objective>

CONSTRAINTS:
- <Bullet list of rules, protections, no-bypass requirements>
- <GitHub is source of truth>
- <Fix errors, do not bypass>
- <Protected zones are off-limits>

EXECUTION STEPS:
1. <First step with clear action>
2. <Second step with clear action>
3. <Subsequent steps...>

STOP CONDITION:
<Where execution must pause for human review or next handover>
```

---

## Handover Types

### 1. Claude → Warp (Execution Handover)

**When to Use:**
- Design phase is complete
- Execution is needed (file ops, commands, Git commits)
- Testing or validation required

**Template:** See `prompts/handover_claude_to_warp.md`

**Example:**
```
HANDOVER TO: Warp

TASK TYPE: Execution

SOURCE OF TRUTH:
- Repo(s): ai-governance, CHAT_ANALYZER_MASTER
- Branch: main
- Rules: GLOBAL_AI_RULES.md, CAPABILITIES_MANIFEST.md

GOAL:
Create PROJECT_RULES.md in CHAT_ANALYZER_MASTER with project-specific conventions.

CONSTRAINTS:
- GitHub is source of truth
- Follow WARP.md format from examples
- No secrets in file content
- Commit with co-author line

EXECUTION STEPS:
1. Read existing WARP.md examples from hourly-autopilot-system
2. Create PROJECT_RULES.md with project-specific content
3. Stage file: git add PROJECT_RULES.md
4. Commit with message: "Add PROJECT_RULES.md for governance compliance"
5. Include co-author: Co-Authored-By: Warp <agent@warp.dev>
6. Push to GitHub

STOP CONDITION:
STOP after push completes and report commit hash.
```

---

### 2. Warp → Claude (Review Handover)

**When to Use:**
- Execution is complete
- Review or audit needed
- Error encountered requiring design decision
- Next steps need architectural input

**Template:** See `prompts/handover_warp_to_claude_review.md`

**Example:**
```
HANDOVER TO: Claude

TASK TYPE: Review

SOURCE OF TRUTH:
- Repo(s): ai-governance
- Branch: main
- Rules: GLOBAL_AI_RULES.md

INPUTS:
- Execution completed: Created 10 governance files
- Commit hash: abc123def456
- All files committed to GitHub
- No errors encountered

REVIEW GOAL:
Verify governance framework is complete and compliant with RULE 12-15.

REVIEW CHECKLIST:
- [ ] All required files present
- [ ] GLOBAL_AI_RULES.md contains RULE 12-15
- [ ] HANDOVER_PROTOCOL.md follows specification
- [ ] Prompts directory populated
- [ ] .gitignore protects secrets
- [ ] Commit includes co-author line

NEXT STEPS:
Determine if any additional governance documents or project-level updates are needed.
```

---

### 3. Claude Self-Routing

**When to Use:**
- Task received that belongs to Warp
- Immediate routing needed (RULE 15)

**Template:** See `prompts/task_router.md`

**Example:**
```
TASK CLASSIFICATION:

Task: "Create a backup of the governance repository"

Classification: File Operations / Execution
→ Route to: Warp

Reason: Involves Git commands and file operations

HANDOVER TO: Warp
[... full handover format follows ...]
```

---

## Required Elements

### GOAL (Mandatory)

**Must be:**
- One clear sentence
- Specific and actionable
- Measurable outcome

**Good Examples:**
- "Create WARP.md file in project X with standard template"
- "Review execution report for compliance with RULE 12"
- "Scan repositories for uncommitted .env files"

**Bad Examples:**
- "Do something with files" (too vague)
- "Fix the project" (not specific)
- "Make it better" (not measurable)

---

### CONSTRAINTS (Mandatory)

**Must include:**
- GitHub is source of truth
- Relevant governance rules (by name)
- Protected zone warnings if applicable
- "Fix errors, do not bypass" if error handling expected
- Secret handling requirements if secrets involved

**Minimum Constraints:**
```
CONSTRAINTS:
- GitHub is source of truth
- Follow GLOBAL_AI_RULES.md (RULE 12-15)
- Protected zones off-limits
- No secrets in commits
```

---

### EXECUTION STEPS (Mandatory for Warp Handovers)

**Must be:**
- Numbered sequentially
- Clear and unambiguous
- Executable by Warp without interpretation
- Include verification steps

**Good Step:**
```
3. Create file: C:\Users\bermi\Projects\ai-governance\README.md
   - Content: [specific content or reference to template]
   - Verify file exists after creation
```

**Bad Step:**
```
3. Make a README or something similar
```

---

### STOP CONDITION (Mandatory)

**Must specify:**
- When to pause execution
- What to report back
- Who receives the report (Claude, User, or both)

**Good Examples:**
- "STOP after commit and report commit hash to user"
- "STOP if error encountered and hand back to Claude with error details"
- "STOP after step 5 for user approval before proceeding to step 6"

**Bad Examples:**
- "Stop when done" (vague)
- "Report results" (to whom?)

---

## Handover Anti-Patterns

### ❌ Ambiguous Instructions

```
EXECUTION STEPS:
1. Fix the file
2. Update things
3. Make it work
```

**Problem:** Requires interpretation and judgment calls

---

### ❌ Missing Constraints

```
GOAL: Create new project

EXECUTION STEPS:
1. Make directories
2. Add files
```

**Problem:** No reference to governance rules, GitHub, or protections

---

### ❌ Combined Roles

```
HANDOVER TO: Warp

TASK TYPE: Design and Execute

GOAL: Figure out what needs to be done and do it
```

**Problem:** Violates RULE 12 (role separation)

---

### ❌ No Stop Condition

```
EXECUTION STEPS:
1. Do task A
2. Do task B
3. Do task C
```

**Problem:** Unclear when execution is complete or needs review

---

## Handover Validation

Before handing over, Claude MUST verify:

- [ ] Handover uses standard format
- [ ] GOAL is one clear sentence
- [ ] CONSTRAINTS include GitHub and relevant rules
- [ ] EXECUTION STEPS are numbered and specific
- [ ] STOP CONDITION is clear
- [ ] No steps require design decisions by Warp
- [ ] No ambiguous language ("fix", "improve", "make better")
- [ ] Secret handling specified if secrets involved

**If any checkbox is unchecked, handover is invalid and must be revised.**

---

## Handover Acceptance

When Warp receives a handover, Warp MUST verify:

- [ ] Format matches HANDOVER_PROTOCOL.md
- [ ] All required sections present
- [ ] Steps are within Warp capabilities (per CAPABILITIES_MANIFEST.md)
- [ ] No architectural decisions required
- [ ] Constraints are enforceable

**If any checkbox is unchecked, Warp must reject the handover and request revision.**

---

## Error Handling in Handovers

### If Warp Encounters Error During Execution

1. **STOP immediately** at the step where error occurred
2. **Capture error details**:
   - Step number
   - Command/action attempted
   - Error message
   - Exit code (if applicable)
3. **Do not improvise solutions**
4. **Hand back to Claude** with error report using review handover format
5. **Wait for revised handover**

### If Claude Discovers Error in Design

1. **Revise the handover** with corrected steps
2. **Mark revision clearly**: "REVISED HANDOVER (v2)"
3. **Explain what changed** in brief note at top
4. **Re-submit to Warp**

---

## Handover Revisions

### Version Tracking

```
HANDOVER TO: Warp
VERSION: 2 (Revised: step 3 corrected)

[... rest of handover ...]
```

### Revision Log

Include brief note at top:
```
REVISION NOTES:
- v1: Initial handover
- v2: Step 3 corrected - wrong file path
```

---

## Checkpoint Handovers

For long workflows, use checkpoints:

```
EXECUTION STEPS:
1. Do step A
2. Do step B
3. Do step C

STOP CONDITION:
STOP after step 3 and report progress.
Wait for user approval before continuing to next phase.

NEXT PHASE:
4. Do step D
5. Do step E
[... to be executed after checkpoint ...]
```

---

## Multi-Step Handovers

For complex workflows spanning multiple handovers:

### Phase 1 Handover
```
HANDOVER TO: Warp (Phase 1 of 3)

GOAL: Complete setup phase

EXECUTION STEPS:
[... phase 1 steps ...]

STOP CONDITION:
STOP after phase 1 and hand back to Claude for phase 2 planning.
```

### Phase 2 Handover
```
HANDOVER TO: Warp (Phase 2 of 3)

DEPENDENCIES:
- Phase 1 completed successfully
- Files from phase 1: X, Y, Z

GOAL: Complete build phase

EXECUTION STEPS:
[... phase 2 steps ...]
```

---

## Emergency Handovers

If immediate action needed (e.g., security incident):

```
HANDOVER TO: Warp (URGENT)

PRIORITY: Emergency - Execute Immediately

GOAL: Rotate compromised API key

CONSTRAINTS:
- Follow SECRETS_POLICY.md rotation procedure
- No delays for approvals

EXECUTION STEPS:
1. Update C:\Users\bermi\.env with new ANTHROPIC_API_KEY
2. Update C:\tools\.env if key exists there
3. Document rotation in SECRET_ROTATION_LOG.md
4. Commit log to ai-governance

STOP CONDITION:
STOP after commit and verify old key is revoked at provider.
```

**Note:** Even emergency handovers follow the standard format.

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2025-12-18 | Initial handover protocol | Claude (designed) / Warp (committed) |

---

**Next Review Date:** 2025-01-18  
**Document Owner:** ai-governance repository  
**Compliance:** RULE 13 (Mandatory Handover Protocol)

---

**Co-Authored-By: Warp <agent@warp.dev>**
