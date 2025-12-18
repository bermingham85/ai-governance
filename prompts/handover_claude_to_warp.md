# HANDOVER: Design to Execution (Claude → Warp)

**Template Version:** 1.0.0  
**Governance:** RULE 13 (Mandatory Handover Protocol)  
**Usage:** Claude uses this template for all execution handovers to Warp

---

## Template

```
═══════════════════════════════════════════════════════════════
                    HANDOVER TO: Warp
═══════════════════════════════════════════════════════════════

TASK TYPE: Execution

SOURCE OF TRUTH:
- GitHub repo(s): <list repositories>
- Branch: <branch name>
- Rules: GLOBAL_AI_RULES.md, CAPABILITIES_MANIFEST.md, <other relevant rules>

───────────────────────────────────────────────────────────────

GOAL:
<One clear sentence describing what needs to be accomplished>

───────────────────────────────────────────────────────────────

CONSTRAINTS:
- GitHub is source of truth
- Fix errors, do not bypass
- Protected zones are off-limits (Photos, personal files, Fillmore/Filmora)
- <Additional project-specific constraints>

───────────────────────────────────────────────────────────────

EXECUTION STEPS:
1. <First step with clear action and verification>
2. <Second step with clear action and verification>
3. <Continue with all steps...>
4. <Each step must be unambiguous>
5. <Include verification steps>

───────────────────────────────────────────────────────────────

STOP CONDITION:
STOP after step <number> and report <what to report> to <user/Claude>.

───────────────────────────────────────────────────────────────
```

---

## Usage Guidelines

### When to Use

- Design phase is complete
- File operations required (read, write, move, delete)
- Command execution needed (shell, scripts, Git)
- Code compilation or testing
- Repository operations (clone, commit, push)

### Before Handover Checklist

Claude MUST verify:
- [ ] All steps are within Warp's capabilities (check CAPABILITIES_MANIFEST.md)
- [ ] No architectural decisions required from Warp
- [ ] All paths are absolute and correct
- [ ] Secret handling specified if secrets involved
- [ ] Error handling instructions included
- [ ] Stop condition is clear
- [ ] No ambiguous language ("fix", "improve", "make better")

### Common Patterns

**Pattern: Create File**
```
1. Create file: C:\Users\bermi\Projects\<repo>\<filename>
   Content: [specific content or reference]
   Verify: File exists after creation
```

**Pattern: Git Operations**
```
1. Stage files: git add <filename>
2. Commit with message: "<message>"
   Include co-author: Co-Authored-By: Warp <agent@warp.dev>
3. Push to remote: git push origin <branch>
4. Verify: Confirm push succeeded
```

**Pattern: Run Commands**
```
1. Execute: <command>
   Expected output: <what should happen>
   On error: Report error details and stop
```

**Pattern: Multi-File Operation**
```
1. For each file in [list]:
   - Read file
   - Apply transformation: <specific transformation>
   - Write back to same location
   - Verify: File modified correctly
```

---

## Examples

### Example 1: Simple File Creation

```
HANDOVER TO: Warp

TASK TYPE: Execution

SOURCE OF TRUTH:
- GitHub repo(s): ai-governance
- Branch: main
- Rules: GLOBAL_AI_RULES.md, HANDOVER_PROTOCOL.md

GOAL:
Create prompts/example_template.md in ai-governance repository.

CONSTRAINTS:
- GitHub is source of truth
- Follow existing template format
- No secrets in file
- Commit with co-author line

EXECUTION STEPS:
1. Create file: C:\Users\bermi\Projects\ai-governance\prompts\example_template.md
   Content:
   ```
   # Example Template
   ...
   ```
2. Stage file: git -C C:\Users\bermi\Projects\ai-governance add prompts/example_template.md
3. Commit: git -C C:\Users\bermi\Projects\ai-governance commit -m "Add example template"
   Co-author: Co-Authored-By: Warp <agent@warp.dev>
4. Push: git -C C:\Users\bermi\Projects\ai-governance push origin main
5. Verify: Confirm file visible on GitHub

STOP CONDITION:
STOP after push and report commit hash.
```

---

### Example 2: Multi-Step Workflow

```
HANDOVER TO: Warp

TASK TYPE: Execution

SOURCE OF TRUTH:
- GitHub repo(s): CHAT_ANALYZER_MASTER
- Branch: main
- Rules: GLOBAL_AI_RULES.md, PROJECT_RULES.md (if exists)

GOAL:
Add standard project structure folders and documentation to CHAT_ANALYZER_MASTER.

CONSTRAINTS:
- GitHub is source of truth
- Do not modify existing files
- Create only missing folders
- Follow existing project patterns

EXECUTION STEPS:
1. Check if folders exist: docs/, scripts/, tests/
   List: Get-ChildItem -Path C:\Users\bermi\Projects\CHAT_ANALYZER_MASTER -Directory

2. Create missing folders:
   - If docs/ missing: New-Item -ItemType Directory -Path "...\docs"
   - If scripts/ missing: New-Item -ItemType Directory -Path "...\scripts"
   - If tests/ missing: New-Item -ItemType Directory -Path "...\tests"

3. Create .gitkeep in each new empty folder to track in Git

4. Stage new folders: git add docs/ scripts/ tests/

5. Commit: git commit -m "Add standard project structure folders"
   Include: Co-Authored-By: Warp <agent@warp.dev>

6. Push: git push origin main

STOP CONDITION:
STOP after push and report which folders were created.
```

---

### Example 3: With Error Handling

```
HANDOVER TO: Warp

TASK TYPE: Execution

SOURCE OF TRUTH:
- GitHub repo(s): ai-governance
- Branch: main
- Rules: GLOBAL_AI_RULES.md, SECRETS_POLICY.md

GOAL:
Scan all project repositories for uncommitted .env files and report findings.

CONSTRAINTS:
- GitHub is source of truth
- Do NOT display .env contents
- Do NOT modify any files
- Read-only scan operation

EXECUTION STEPS:
1. Get list of all Git repositories under C:\Users\bermi\Projects\
   Command: Get-ChildItem -Path C:\Users\bermi\Projects\ -Directory | Where-Object { Test-Path (Join-Path $_.FullName ".git") }

2. For each repository:
   - Check Git status for .env files
   - Command: git -C <repo> status --porcelain | Select-String ".env"
   - If .env files found: Add to report list (path only, no contents)
   - If error: Report which repo and error message

3. Compile findings:
   - Total repositories scanned: <count>
   - Repositories with uncommitted .env: <count>
   - List of affected repositories: <list paths only>

4. If uncommitted .env files found:
   - Do NOT commit them
   - Do NOT display their contents
   - Report findings to user for manual review

STOP CONDITION:
STOP after scan completes and report findings.
Do NOT take any action on .env files without explicit user approval.
```

---

## Anti-Patterns to Avoid

### ❌ Vague Instructions
```
EXECUTION STEPS:
1. Fix the file
2. Make it work
```

### ❌ Requiring Judgment
```
EXECUTION STEPS:
1. Decide which approach is best
2. Implement the solution
```

### ❌ Missing Verification
```
EXECUTION STEPS:
1. Create file
2. Done
```

### ❌ No Error Handling
```
EXECUTION STEPS:
1. Run command
2. Continue regardless of result
```

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2025-12-18 | Initial template | Claude (designed) / Warp (committed) |

---

**Template Owner:** ai-governance repository  
**Compliance:** RULE 13 (Mandatory Handover Protocol)

---

**Co-Authored-By: Warp <agent@warp.dev>**
