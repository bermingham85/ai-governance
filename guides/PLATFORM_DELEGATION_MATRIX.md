# PLATFORM DELEGATION MATRIX

**Version:** 1.0  
**Last Updated:** 2026-01-13  
**Owner:** AI Operations  
**Related:** HANDOVER_PROTOCOL.md, GLOBAL_AI_RULES.md, ERROR_HANDLING_PROTOCOL.md

---

## PURPOSE

Ensure every task is routed to the optimal platform based on task type, preventing role violations and maximizing efficiency.

---

## PLATFORM CAPABILITIES

### 🎨 Claude (Anthropic)
**Role:** Designer, Reviewer, Strategist  
**Strengths:** Deep reasoning, architecture, code review, documentation  
**Restrictions:** NEVER executes, NEVER writes files, NEVER commits

**Best For:**
- System architecture and design
- Code review and audit
- Technical documentation
- Strategy and planning
- Complex reasoning tasks
- ADR (Architecture Decision Records)
- Research and analysis

---

### ⚡ Warp Agent
**Role:** Executor, Implementer, Operator  
**Strengths:** File operations, git operations, shell commands, testing  
**Restrictions:** NEVER designs systems, NEVER makes architectural decisions

**Best For:**
- File creation/editing
- Git operations (commit, push, branch)
- Shell command execution
- Running tests and builds
- Deployment operations
- Dependency management
- Environment setup

---

### 🗄️ GitHub
**Role:** Source of Truth, Version Control, Collaboration  
**Strengths:** Version history, code review, CI/CD, project management

**Best For:**
- Source code storage
- Version control
- Pull request reviews
- Issue tracking
- CI/CD automation
- Release management

---

### 🧠 GPT-4 (OpenAI)
**Role:** Alternative Designer/Analyst  
**Strengths:** Broad knowledge, quick iterations, API integration  
**Restrictions:** Same as Claude (no execution)

**Best For:**
- Rapid prototyping ideas
- API-heavy integrations
- Alternative perspectives on designs
- Quick research tasks

---

## DELEGATION DECISION TREE

```
┌─────────────────────────────────────────────────────┐
│ Is this a DESIGN or IMPLEMENTATION task?           │
├─────────────────────────────────────────────────────┤
│                                                     │
│ DESIGN (what/why/how)                              │
│   ↓                                                 │
│   Does it require deep reasoning?                  │
│   ├─ Yes → Claude                                   │
│   ├─ No, quick/simple → GPT-4                      │
│   └─ Review needed → Claude (after GPT-4 draft)    │
│                                                     │
│ IMPLEMENTATION (do it)                             │
│   ↓                                                 │
│   Does it modify files/systems?                    │
│   ├─ Yes → Warp                                     │
│   └─ No, just read → Warp (read-only operations)  │
│                                                     │
│ STORAGE/REVIEW                                     │
│   ↓                                                 │
│   GitHub (always source of truth)                  │
└─────────────────────────────────────────────────────┘
```

---

## TASK TYPE ROUTING TABLE

| Task Type | Primary | Secondary | Prohibited |
|-----------|---------|-----------|------------|
| **Architecture Design** | Claude | GPT-4 | Warp |
| **System Design Doc** | Claude | - | Warp |
| **Code Review** | Claude | GitHub PR | Warp |
| **ADR Creation** | Claude | - | Warp |
| **File Creation** | Warp | - | Claude, GPT-4 |
| **File Editing** | Warp | - | Claude, GPT-4 |
| **Git Operations** | Warp | GitHub CLI | Claude, GPT-4 |
| **Shell Commands** | Warp | - | Claude, GPT-4 |
| **Testing Execution** | Warp | CI/CD | Claude, GPT-4 |
| **Deployment** | Warp | CI/CD | Claude, GPT-4 |
| **Code Storage** | GitHub | - | - |
| **PR Review** | GitHub + Claude | - | Warp |
| **Issue Tracking** | GitHub | - | - |
| **Research/Analysis** | Claude | GPT-4 | - |
| **Quick Prototypes** | GPT-4 → Warp | Claude review | - |
| **Documentation** | Claude | GPT-4 | - |
| **Implementation** | Warp | - | Claude, GPT-4 |

---

## HANDOVER PROTOCOLS

### From User → Claude (Design Request)
```markdown
**HANDOVER TO CLAUDE**

Task: [Design system architecture for X]
Context: [Current state, requirements, constraints]
Deliverable: [ADR, design doc, code review]
Output Format: Design document in markdown (do NOT create files)
Next Step: Warp will implement your design

Restrictions:
- Design only, DO NOT execute
- DO NOT suggest file creation commands
- Provide design for Warp to implement
```

### From Claude → Warp (Implementation Handover)
```markdown
**HANDOVER TO WARP**

Design Complete: [Link to design doc or summary]
Implementation Tasks:
1. Create file X with content Y
2. Update file A at line N
3. Run tests
4. Commit with message Z

Acceptance Criteria:
- All tests pass
- Code follows DEFINITION_OF_DONE.md
- Changes committed and pushed

Design Decisions:
- [Key architectural choices]
- [Rationale for approach]
```

### From Warp → Claude (Review Request)
```markdown
**HANDOVER TO CLAUDE FOR REVIEW**

Implementation Complete: [Commit hash or file list]
Changes Made:
- Created: [files]
- Modified: [files]
- Tests: [status]

Review Needed For:
- Architecture alignment
- Code quality
- Security concerns
- Performance implications

Please review and provide feedback (do NOT modify files).
```

### From Warp → GitHub (Storage)
```bash
# Always commit and push after implementation
git add [files]
git commit -m "[message]

Co-Authored-By: Claude <claude@anthropic.com>  # If designed by Claude
Co-Authored-By: Warp <agent@warp.dev>"
git push origin [branch]
```

---

## EMERGENT TASK HANDLING

### What is an Emergent Task?
Unplanned work that arises during implementation:
- Unexpected errors/bugs
- Missing dependencies
- Configuration issues
- Integration problems
- Performance bottlenecks

### Emergent Task Decision Matrix

```
┌──────────────────────────────────────────────────────┐
│ SEVERITY ASSESSMENT                                  │
├──────────────────────────────────────────────────────┤
│ Can fix in <5 minutes? (Simple)                     │
│   ↓ YES                                              │
│   └─→ Warp: Fix immediately, document in commit     │
│                                                      │
│ Requires design change? (Medium)                    │
│   ↓ YES                                              │
│   └─→ Pause → Claude: Review design → Warp: Revise  │
│                                                      │
│ Blocks entire workflow? (Critical)                  │
│   ↓ YES                                              │
│   └─→ ESCALATE: Document, create issue, notify user │
└──────────────────────────────────────────────────────┘
```

### Emergent Task Protocol

#### 🟢 LEVEL 1: Simple (Auto-Fix)
**Examples:** Missing semicolon, typo, linting error, missing import

**Action:**
```markdown
1. Warp fixes immediately
2. Document in commit message:
   "Fixed emergent issue: [description]"
3. Continue with original task
4. No handover needed
```

#### 🟡 LEVEL 2: Medium (Design Consultation)
**Examples:** API mismatch, architectural inconsistency, security concern

**Action:**
```markdown
1. Warp pauses implementation
2. Document issue with context
3. Handover to Claude:
   "EMERGENT ISSUE: [description]
    Original Design: [summary]
    Problem: [what's broken]
    Options: [possible fixes]
    Recommendation needed."
4. Claude reviews and provides solution
5. Warp implements Claude's solution
6. Resume original task
```

#### 🔴 LEVEL 3: Critical (Escalate)
**Examples:** Third-party API down, database corruption, security breach

**Action:**
```markdown
1. Warp STOPS immediately
2. Document issue thoroughly
3. Create GitHub issue with:
   - Severity: CRITICAL
   - Impact: [what's blocked]
   - Context: [full details]
   - Logs/screenshots
4. Notify user immediately
5. Wait for user decision
6. DO NOT proceed until resolved
```

---

## BUILD INSTRUCTIONS WITH EMERGENT HANDLING

### Standard Build Process
```yaml
# Every project should have this in README.md or BUILD.md

Build Steps:
  1. Prerequisites Check:
     - [ ] Dependencies installed (package.json, requirements.txt, etc.)
     - [ ] Environment variables set (.env.example → .env)
     - [ ] Database running (if applicable)
     - [ ] Required services available

  2. Build:
     - [ ] Run build command (npm run build, make, etc.)
     - [ ] Check for build errors
     - [ ] Verify output artifacts

  3. Test:
     - [ ] Run unit tests (≥80% coverage)
     - [ ] Run integration tests
     - [ ] Check test results

  4. Deploy (if applicable):
     - [ ] Deploy to target environment
     - [ ] Verify deployment health
     - [ ] Run smoke tests

Emergent Issue Handling:
  - Level 1 (Simple): Fix and document
  - Level 2 (Medium): Consult Claude, then fix
  - Level 3 (Critical): STOP, escalate to user
```

### Build Instruction Template
Every project MUST include this in README.md:

```markdown
## Build Instructions

### Prerequisites
- Node.js 18+ / Python 3.9+ / [language + version]
- [Database] running on localhost:[port]
- Environment variables (see .env.example)

### Quick Start
\`\`\`bash
# 1. Install dependencies
npm install  # or pip install -r requirements.txt

# 2. Setup environment
cp .env.example .env
# Edit .env with your values

# 3. Run tests
npm test  # Verify ≥80% coverage

# 4. Build
npm run build

# 5. Start
npm start
\`\`\`

### Troubleshooting
If you encounter issues:
1. **Simple errors** (typos, missing deps): Fix and document
2. **Design issues** (API changes, architecture): Consult Claude
3. **Critical blocks** (service down, security): STOP and escalate

### Expected Build Time
- Clean build: ~5 minutes
- With tests: ~10 minutes
- Full CI/CD: ~15 minutes

### Build Outputs
- Artifacts: `dist/` or `build/`
- Logs: `logs/build.log`
- Coverage: `coverage/index.html`
```

---

## ANTI-PATTERNS (VIOLATIONS)

### ❌ Claude Executing
```markdown
# WRONG - Claude should NEVER do this:
Claude: "I'll create the file for you..."
Claude: "I'll commit these changes..."
Claude: "I'll run the tests..."

# RIGHT:
Claude: "Here's the design. HANDOVER TO WARP:
  Warp, please create file X with content Y..."
```

### ❌ Warp Designing
```markdown
# WRONG - Warp should NEVER do this:
Warp: "I'll redesign the authentication system..."
Warp: "Let me refactor the entire architecture..."
Warp: "I'll choose between approach A or B..."

# RIGHT:
Warp: "Implementation blocked. HANDOVER TO CLAUDE:
  Need design decision: Should auth use JWT or sessions?"
```

### ❌ Missing GitHub Storage
```markdown
# WRONG - Work not saved:
Warp: "I made the changes locally."
[No commit, no push]

# RIGHT:
Warp: "Changes implemented and pushed to GitHub:
  Commit: abc123
  Files: src/auth.ts, tests/auth.test.ts"
```

### ❌ Ignoring Emergent Issues
```markdown
# WRONG - Proceeding despite critical error:
Warp: "Database connection failed, but continuing with other tasks..."

# RIGHT:
Warp: "CRITICAL EMERGENT ISSUE: Database unreachable.
  STOPPING all work. Creating issue #123.
  User action required."
```

---

## DELEGATION CHECKLIST

Before starting ANY task, verify:

```markdown
- [ ] Task classification clear (Design vs Implementation)
- [ ] Correct platform assigned
- [ ] Handover protocol followed (if multi-platform)
- [ ] GitHub is source of truth (latest code pulled)
- [ ] Emergent issue protocol ready
- [ ] Build instructions available
- [ ] Success criteria defined
- [ ] Co-author attribution prepared
```

---

## ESCALATION PATHS

### When Platforms Disagree
```
User assigns wrong platform
  ↓
Platform detects violation
  ↓
Platform refuses and explains
  ↓
Platform suggests correct routing
  ↓
User re-assigns to correct platform
```

**Example:**
```markdown
User: "Claude, please create this file."
Claude: "I cannot create files (GLOBAL_AI_RULES.md Rule 14).
  This is an implementation task.
  HANDOVER TO WARP: [design details]"
```

### When Task is Ambiguous
```
User request unclear
  ↓
Platform asks clarifying questions:
  - Is this design or implementation?
  - What's the deliverable?
  - Who should execute?
  ↓
User clarifies
  ↓
Platform proceeds or hands over
```

---

## METRICS & COMPLIANCE

### Track These Metrics
- **Role Violations:** Count of Claude executing or Warp designing
- **Handover Success:** % of clean handovers (no back-and-forth)
- **Emergent Issues:** Count by severity level
- **GitHub Sync:** % of work committed and pushed
- **Build Success:** % of builds passing first try

### Monthly Review
```markdown
# Platform Delegation Report: [Month Year]

**Role Compliance:**
- Claude execution violations: X (target: 0)
- Warp design violations: X (target: 0)

**Handover Efficiency:**
- Clean handovers: X% (target: >95%)
- Average handover time: X minutes

**Emergent Issues:**
- Level 1 (Simple): X (auto-resolved)
- Level 2 (Medium): X (Claude consulted)
- Level 3 (Critical): X (user escalated)

**Storage Compliance:**
- Work committed to GitHub: X% (target: 100%)
- Co-author attribution: X% (target: 100%)

**Action Items:**
- [Improvement needed]
```

---

## QUICK REFERENCE

### Task Assignment Guide
```
"Design this system" → Claude
"Build this feature" → Warp (with Claude's design)
"Review this code" → Claude
"Fix this bug" → Warp (if simple) or Claude → Warp (if complex)
"Create documentation" → Claude
"Run the tests" → Warp
"Make this commit" → Warp
"Should we use X or Y?" → Claude
"Deploy to production" → Warp (following runbook)
"Something broke during build" → Emergent Protocol
```

### Emergency Contacts
```
Role Violation: Refer to GLOBAL_AI_RULES.md
Emergent Issue: Follow severity protocol above
Handover Confusion: See HANDOVER_PROTOCOL.md
Build Failure: Check BUILD.md or project README
```

---

**Related Documents:**
- GLOBAL_AI_RULES.md - Core platform rules
- HANDOVER_PROTOCOL.md - Detailed handover templates
- ERROR_HANDLING_PROTOCOL.md - Error classification
- DEFINITION_OF_DONE.md - Task completion criteria
- PROJECT_DECISION_MATRIX.md - New vs extend decisions

**Co-Authored-By: Warp <agent@warp.dev>**
