# TASK ROUTER: Classification and Routing Logic

**Template Version:** 1.0.0  
**Governance:** RULE 15 (Automatic Task Routing)  
**Usage:** Claude uses this to classify tasks and route appropriately

---

## Purpose

Before responding to any task, Claude MUST classify it and route to the appropriate system.

**Key Principle:** No system can choose to "just do it here" — routing is mandatory.

---

## Task Classification Decision Tree

```
Task Received
    │
    ├─> Design/Architecture?
    │   └─> YES → Stay in Claude
    │
    ├─> Review/Audit?
    │   └─> YES → Stay in Claude
    │
    ├─> File Operations?
    │   └─> YES → HANDOVER TO Warp
    │
    ├─> Command Execution?
    │   └─> YES → HANDOVER TO Warp
    │
    ├─> Git Operations?
    │   └─> YES → HANDOVER TO Warp
    │
    ├─> Source of Truth Update?
    │   └─> YES → HANDOVER TO Warp (GitHub commit)
    │
    └─> Mixed (Design + Execution)?
        └─> Split into phases:
            1. Design (Claude)
            2. Handover to Warp
            3. Execution (Warp)
            4. Review (back to Claude if needed)
```

---

## Classification Rules

### Design / Architecture → Stay in Claude

**Indicators:**
- "Design a system..."
- "Create a plan for..."
- "How should I architect..."
- "What's the best approach..."
- "Review this design..."

**Examples:**
- "Design a data model for X"
- "Create an API design for Y"
- "Propose an architecture for Z"
- "Review this execution report"

**Action:** Claude handles directly, no handover needed

---

### Review / Audit → Stay in Claude

**Indicators:**
- "Review this code..."
- "Audit for compliance..."
- "Check if this follows..."
- "Validate this approach..."
- "Does this meet requirements..."

**Examples:**
- "Review this execution report"
- "Audit compliance with RULE 12-15"
- "Check if all governance files are complete"
- "Validate this WARP.md handover"

**Action:** Claude handles directly, no handover needed

---

### File Operations → HANDOVER TO Warp

**Indicators:**
- "Create a file..."
- "Update this file..."
- "Delete these files..."
- "Move files from X to Y..."
- "Scan the filesystem..."

**Examples:**
- "Create PROJECT_RULES.md"
- "Update GLOBAL_AI_RULES.md"
- "Scan for .env files"
- "Copy templates to project"

**Action:** Create handover using `prompts/handover_claude_to_warp.md`

---

### Command Execution → HANDOVER TO Warp

**Indicators:**
- "Run this command..."
- "Execute this script..."
- "Install packages..."
- "Compile the code..."
- "Run tests..."

**Examples:**
- "Run npm install"
- "Execute the build script"
- "Test the new feature"
- "Check the server status"

**Action:** Create handover using `prompts/handover_claude_to_warp.md`

---

### Git Operations → HANDOVER TO Warp

**Indicators:**
- "Commit these changes..."
- "Push to GitHub..."
- "Create a branch..."
- "Clone this repository..."
- "Check Git status..."

**Examples:**
- "Commit the governance files"
- "Push to main branch"
- "Create a feature branch"
- "Check for uncommitted files"

**Action:** Create handover using `prompts/handover_claude_to_warp.md`

---

### Source of Truth Updates → HANDOVER TO Warp (GitHub)

**Indicators:**
- "Update governance docs..."
- "Change WARP.md..."
- "Modify rules..."
- "Add new template..."

**Examples:**
- "Add RULE 16 to GLOBAL_AI_RULES.md"
- "Update HANDOVER_PROTOCOL.md"
- "Create new prompt template"

**Action:**
1. Claude designs the change
2. Create handover to Warp for execution
3. Warp commits to GitHub

---

### Mixed Tasks → Split into Phases

**Indicators:**
- Task requires both design and execution
- Multi-step workflow with different role requirements

**Examples:**
- "Create a new project structure with governance compliance"
  - Phase 1 (Claude): Design the structure
  - Phase 2 (Warp): Execute file creation
  - Phase 3 (Claude): Review results

**Action:**
1. Claude completes design phase first
2. Create handover for execution phase
3. Wait for Warp to complete
4. Review results if needed

---

## Routing Template

Use this template when routing:

```
TASK CLASSIFICATION:

Task: "<original user task>"

Classification: <Design | Review | Execution | Mixed>

Reasoning: <why this classification>

Route to: <Claude | Warp | GitHub>

<If routing to Warp, include full handover>
<If staying in Claude, proceed with response>
<If mixed, break down into phases>
```

---

## Examples

### Example 1: Simple Classification

**Task:** "Review the ai-governance repository for completeness"

```
TASK CLASSIFICATION:

Task: "Review the ai-governance repository for completeness"

Classification: Review

Reasoning: Task requires audit of existing files against governance requirements.
This is within Claude's review capabilities.

Route to: Claude

<Claude proceeds with review directly>
```

---

### Example 2: Execution Required

**Task:** "Create WARP.md for the ComfyUI project"

```
TASK CLASSIFICATION:

Task: "Create WARP.md for the ComfyUI project"

Classification: Execution (File Operations)

Reasoning: Requires file creation and Git commit. This is Warp's responsibility.

Route to: Warp

HANDOVER TO: Warp

TASK TYPE: Execution

SOURCE OF TRUTH:
- GitHub repo(s): ComfyUI
- Branch: main
- Rules: GLOBAL_AI_RULES.md, CAPABILITIES_MANIFEST.md

GOAL:
Create WARP.md file in ComfyUI project with project-specific guidance.

CONSTRAINTS:
- GitHub is source of truth
- Follow WARP.md format from examples
- Include ComfyUI-specific patterns
- Commit with co-author line

EXECUTION STEPS:
1. Read example WARP.md from hourly-autopilot-system for reference
2. Create C:\Users\bermi\Projects\ComfyUI\WARP.md
   Content: [project-specific WARP.md content]
3. Stage: git -C C:\Users\bermi\Projects\ComfyUI add WARP.md
4. Commit: git commit -m "Add WARP.md for governance compliance"
   Co-author: Co-Authored-By: Warp <agent@warp.dev>
5. Push: git push origin main

STOP CONDITION:
STOP after push and report commit hash.
```

---

### Example 3: Mixed Task

**Task:** "Set up governance compliance for all projects"

```
TASK CLASSIFICATION:

Task: "Set up governance compliance for all projects"

Classification: Mixed (Design + Execution)

Reasoning: Requires architectural planning (what files, what content)
AND execution (creating files, committing to Git)

Route to: Multi-phase workflow

PHASE 1 (Claude - Design):
1. Analyze current state of all projects
2. Design standard governance structure
3. Create file templates and content
4. Prepare execution plan

PHASE 2 (Warp - Execution):
<After Phase 1 complete, create handover>

PHASE 3 (Claude - Review):
<After Phase 2 complete, review results>
```

---

## Special Cases

### Case: Urgent/Emergency

Even urgent tasks must be routed correctly:

```
TASK: "Rotate compromised API key NOW"

Classification: Execution (Emergency)

Route to: Warp (URGENT)

<Create emergency handover with URGENT priority>
```

**Note:** Emergency handovers still follow standard format.

---

### Case: Ambiguous Task

If task classification is unclear:

```
TASK: "Fix the project"

Classification: AMBIGUOUS

Action: Request clarification from user

Response: "I need clarification to route this correctly:
- What needs fixing? (design issue vs. execution issue)
- Which project?
- What is the expected outcome?

This will help me determine if this is:
- Design work (Claude handles)
- Execution work (handover to Warp)
- Mixed (multi-phase approach)"
```

---

### Case: Question vs. Action

**Question:** "How should I structure the governance framework?"
- Classification: Design question
- Route to: Claude (answer directly)

**Action:** "Structure the governance framework"
- Classification: Execution
- Route to: Warp (after Claude designs it)

---

## Anti-Patterns to Avoid

### ❌ Choosing Convenience Over Rules

**Wrong:**
```
Task: "Create a file"
Reasoning: "I could just show the content, user can create it"
Action: Display content instead of handing over
```

**Right:**
```
Task: "Create a file"
Classification: Execution
Route to: Warp
<Full handover>
```

---

### ❌ Combining Roles

**Wrong:**
```
Task: "Design and implement new feature"
Action: Do both in one step
```

**Right:**
```
Task: "Design and implement new feature"
Classification: Mixed
Phase 1: Design (Claude)
Phase 2: Implement (Warp via handover)
```

---

### ❌ Skipping Classification

**Wrong:**
```
User: "Update the file"
Claude: <just does it>
```

**Right:**
```
User: "Update the file"
Claude: <classifies first>
Classification: Execution
Route to: Warp
<Handover>
```

---

## Routing Checklist

Before responding, Claude MUST ask:

- [ ] Have I classified this task?
- [ ] Is classification correct per routing rules?
- [ ] If execution required, am I handing over?
- [ ] If staying in Claude, is this truly design/review?
- [ ] If mixed, have I broken into phases?
- [ ] Am I following RULE 15 (no choosing to "just do it")?

**If any checkbox unchecked, stop and reclassify.**

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2025-12-18 | Initial task router | Adapted from hourly-autopilot-system / Warp |

---

**Template Owner:** ai-governance repository  
**Compliance:** RULE 15 (Automatic Task Routing)

---

**Co-Authored-By: Warp <agent@warp.dev>**
