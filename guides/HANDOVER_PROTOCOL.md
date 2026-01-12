# HANDOVER PROTOCOL
**Seamless Transitions Between AI Platforms**

**Version:** 1.0.0  
**Last Updated:** 2026-01-12  
**Owner:** AI Governance Lead  
**Review Schedule:** Quarterly

---

## 🎯 PURPOSE

This protocol ensures smooth, efficient handovers between AI platforms (Claude → Warp, Warp → Claude, etc.) with complete context transfer and no lost information.

**Foundational Rule:** From GLOBAL_AI_RULES.md RULE 12:
- **Claude:** Design, review, audit (NO execution)
- **Warp:** Execution, file operations, commands (NO design)

---

## 📋 HANDOVER TRIGGER CONDITIONS

### When Claude Must Hand Over to Warp

Claude MUST hand over when task requires:
- [ ] **File creation/modification** (code, config, docs)
- [ ] **Shell command execution** (git, npm, deployment)
- [ ] **Git operations** (commit, push, branch, merge)
- [ ] **Environment changes** (env vars, system config)
- [ ] **Package installation** (npm install, pip install)
- [ ] **Build/compilation** (npm run build, compile)
- [ ] **Testing execution** (npm test, pytest)
- [ ] **Deployment** (to staging, production)

### When Warp Must Hand Over to Claude

Warp MUST hand over when task requires:
- [ ] **Architecture design** (system design, API design)
- [ ] **Code review** (quality assessment, security review)
- [ ] **Planning** (implementation strategy, task breakdown)
- [ ] **Documentation writing** (technical specs, ADRs)
- [ ] **Debugging strategy** (root cause analysis, investigation)
- [ ] **Decision-making** (technology choice, approach selection)
- [ ] **Audit** (compliance check, security audit)

---

## 📤 HANDOVER FROM CLAUDE TO WARP

### Step 1: Design Complete

Claude completes design phase:
- ✅ Architecture designed
- ✅ Implementation plan documented
- ✅ Code structure defined
- ✅ Edge cases identified
- ✅ Testing strategy outlined

### Step 2: Prepare Handover Package

Claude creates handover document with:

```markdown
# HANDOVER TO WARP

## Task Summary
[One sentence: what needs to be executed]

## Context
- **Goal:** [What we're trying to achieve]
- **Why:** [Business/technical justification]
- **Constraints:** [Any limitations or requirements]

## Design Decisions
- **Architecture:** [Key architectural choices made]
- **Technology:** [Languages, frameworks, tools to use]
- **Patterns:** [Design patterns to follow]
- **ADR Reference:** [Link to ADR if created]

## Implementation Instructions
1. [Step 1: Specific action with file paths]
2. [Step 2: Specific action with commands]
3. [Step 3: Specific action with verification]

## Files to Create/Modify
- `path/to/file1.ts` - [What to add/change]
- `path/to/file2.md` - [What to add/change]

## Commands to Execute
```bash
# Command 1: Purpose
command-here

# Command 2: Purpose
another-command
```

## Testing Requirements
- [ ] Unit tests for [specific functions]
- [ ] Integration test for [specific flow]
- [ ] Manual test: [specific steps]

## Success Criteria
- [ ] [Criterion 1: How to verify]
- [ ] [Criterion 2: How to verify]
- [ ] [Criterion 3: How to verify]

## Rollback Plan
[How to undo if something goes wrong]

## Questions/Clarifications Needed
[Any ambiguities that need user input]
```

### Step 3: Explicit Handover Statement

Claude ends with:
```
🤝 HANDOVER TO WARP

I have completed the design phase. Warp, please execute the implementation per the instructions above.

Handover checklist:
✅ Design complete
✅ Implementation plan provided
✅ Files to modify identified
✅ Commands specified
✅ Success criteria defined
✅ Rollback plan documented

Awaiting execution confirmation from Warp.
```

### Step 4: Warp Acknowledges

Warp must explicitly confirm:
```
✅ HANDOVER RECEIVED FROM CLAUDE

I acknowledge receipt of:
- Task summary: [restate]
- Implementation plan: [confirm understanding]
- Success criteria: [list]

I will now execute the plan. Beginning with step 1...
```

---

## 📥 HANDOVER FROM WARP TO CLAUDE

### Step 1: Execution Complete

Warp completes execution phase:
- ✅ Files created/modified
- ✅ Commands executed successfully
- ✅ Tests passing
- ✅ Changes committed
- ✅ Changes pushed to GitHub

### Step 2: Prepare Handover Package

Warp creates handover document with:

```markdown
# HANDOVER TO CLAUDE

## Execution Summary
[One sentence: what was executed]

## Actions Taken
1. [Action 1: Specific file changes made]
2. [Action 2: Commands executed with output]
3. [Action 3: Commits created]

## Files Changed
- `path/to/file1.ts` - [What changed, why]
- `path/to/file2.md` - [What changed, why]

## Git Operations
- Commit: [commit hash] - [message]
- Branch: [branch name]
- Push: [result]

## Test Results
- Unit tests: [X passing, Y failing]
- Integration tests: [result]
- Manual tests: [outcome]

## Issues Encountered
- [Issue 1: Description and resolution]
- [Issue 2: Description and resolution]

## Deviations from Plan
[Any changes made from original design, with justification]

## Current State
- [What works now]
- [What's ready for review]
- [What needs attention]

## Items Needing Review
- [ ] [Code quality in file X]
- [ ] [Security concern in function Y]
- [ ] [Performance of operation Z]

## Next Steps Recommended
[What should happen next]
```

### Step 3: Explicit Handover Statement

Warp ends with:
```
🤝 HANDOVER TO CLAUDE

I have completed the execution phase. Claude, please review the implementation.

Handover checklist:
✅ Implementation complete
✅ All files modified as planned
✅ Commands executed successfully
✅ Tests passing
✅ Changes pushed to GitHub
✅ Issues documented

Awaiting review confirmation from Claude.
```

### Step 4: Claude Acknowledges

Claude must explicitly confirm:
```
✅ HANDOVER RECEIVED FROM WARP

I acknowledge receipt of:
- Execution summary: [restate]
- Files changed: [list]
- Test results: [confirm]

I will now review the implementation. Beginning review...
```

---

## 🔄 COMPLETE HANDOVER EXAMPLE

### Example: Add New API Endpoint

**User Request:**
> "Add a new GET /api/users/:id endpoint that returns user profile data"

**Claude's Response:**
```markdown
I'll design the API endpoint, then hand over to Warp for implementation.

## Design: GET /api/users/:id Endpoint

### Architecture Decisions
- RESTful endpoint following existing API patterns
- Express.js route handler
- Mongoose for database access
- Input validation with Joi
- JWT authentication required

### Implementation Plan
1. Create route handler in `src/routes/users.ts`
2. Create controller in `src/controllers/userController.ts`
3. Add validation schema in `src/validation/userSchemas.ts`
4. Write unit tests in `tests/unit/userController.test.ts`
5. Write integration test in `tests/integration/users.test.ts`
6. Update API documentation in `docs/api.md`

### Code Structure
[Provides detailed code examples]

🤝 HANDOVER TO WARP

Warp, please implement the above design. Files to create/modify are listed in Implementation Plan section.

Success criteria:
- GET /api/users/:id returns 200 with valid ID
- Returns 404 for non-existent user
- Returns 401 without valid JWT
- Returns 400 for invalid ID format
- All tests pass
```

**Warp's Response:**
```markdown
✅ HANDOVER RECEIVED FROM CLAUDE

I acknowledge:
- Task: Implement GET /api/users/:id endpoint
- Files: 5 files to create/modify
- Tests: Unit and integration tests required

Executing implementation plan...

[Creates files, runs tests, commits, pushes]

✅ EXECUTION COMPLETE

Actions taken:
1. Created src/routes/users.ts with GET /:id handler
2. Created src/controllers/userController.ts with findById logic
3. Added Joi validation in src/validation/userSchemas.ts
4. Wrote 8 unit tests (all passing)
5. Wrote 4 integration tests (all passing)
6. Updated docs/api.md with endpoint documentation

Test results:
- Unit tests: 8/8 passing ✅
- Integration tests: 4/4 passing ✅
- Manual test (Postman): Successful ✅

Git operations:
- Commit: a3f892c - "Add GET /api/users/:id endpoint"
- Branch: feature/user-profile-endpoint
- Pushed to GitHub: Success ✅

🤝 HANDOVER TO CLAUDE

Claude, implementation is complete and ready for your review.

Items for review:
- Code quality in userController.ts
- Error handling completeness
- Test coverage adequacy
```

**Claude's Response:**
```markdown
✅ HANDOVER RECEIVED FROM WARP

Reviewing implementation...

## Code Review Results

### ✅ Strengths
- Clean, readable code following style guide
- Comprehensive error handling
- Good test coverage (95%)
- Proper input validation
- Documentation complete

### 🔍 Suggestions
1. Minor: Add JSDoc comment to findById function
2. Consider: Cache frequently accessed users (future optimization)

### ✅ Approval
Implementation meets all success criteria. Approved for merge.

Recommended next steps:
1. Create PR: feature/user-profile-endpoint → main
2. Merge after CI passes
3. Deploy to staging for final verification
```

---

## 🚫 HANDOVER ANTI-PATTERNS

### ❌ Silent Handover
**Problem:** No explicit handover statement  
**Impact:** Other AI doesn't know it should act  
**Solution:** Always use "🤝 HANDOVER TO [AI]"

### ❌ Incomplete Context
**Problem:** Missing key information in handover  
**Impact:** Receiving AI must ask clarifying questions  
**Solution:** Use complete handover template

### ❌ Role Violation
**Problem:** Claude tries to execute, or Warp tries to design  
**Impact:** Breaks role separation, confusion  
**Solution:** Strictly adhere to RULE 12

### ❌ No Acknowledgment
**Problem:** Receiving AI doesn't confirm receipt  
**Impact:** Uncertainty about who is responsible  
**Solution:** Always acknowledge handover

### ❌ Assumed Context
**Problem:** "Just implement what I described"  
**Impact:** Execution doesn't match intent  
**Solution:** Explicit, detailed instructions

### ❌ Circular Handover
**Problem:** A → B → A → B without progress  
**Impact:** Infinite loop, wasted tokens  
**Solution:** Clear end state, escalate if stuck

---

## 📊 HANDOVER QUALITY CHECKLIST

### Before Handing Over (Sender)

- [ ] **Role check:** Am I the right AI for next step?
- [ ] **Complete:** Have I finished my phase?
- [ ] **Context:** Have I provided all necessary info?
- [ ] **Clear:** Are instructions unambiguous?
- [ ] **Explicit:** Have I stated "HANDOVER TO [AI]"?
- [ ] **Verified:** Have I checked my work?

### After Receiving (Receiver)

- [ ] **Acknowledge:** Have I confirmed receipt?
- [ ] **Understand:** Do I understand the task?
- [ ] **Capable:** Am I the right AI for this?
- [ ] **Complete info:** Do I have everything needed?
- [ ] **Questions:** Have I asked for clarifications if needed?
- [ ] **Ready:** Can I proceed immediately?

---

## 🔍 HANDOVER AUDIT TRAIL

Every handover should be logged for audit purposes:

```markdown
# Handover Log

## Handover #1: Claude → Warp
- **Date:** 2026-01-12 14:30:00
- **Task:** Implement user profile endpoint
- **From:** Claude (Design complete)
- **To:** Warp (For execution)
- **Status:** ✅ Acknowledged by Warp

## Handover #2: Warp → Claude
- **Date:** 2026-01-12 14:45:00
- **Task:** Review implemented endpoint
- **From:** Warp (Execution complete)
- **To:** Claude (For review)
- **Status:** ✅ Acknowledged by Claude

## Handover #3: Claude → User
- **Date:** 2026-01-12 15:00:00
- **Task:** Approval for merge
- **From:** Claude (Review complete)
- **To:** User (For decision)
- **Status:** ✅ User approved
```

---

## 🎯 HANDOVER TEMPLATES

### Template 1: Design → Execution

```markdown
🤝 HANDOVER TO WARP

## Task
[One sentence summary]

## Design Complete
[Architecture, patterns, decisions]

## Implementation Instructions
1. [Step by step]
2. [With file paths]
3. [And commands]

## Success Criteria
- [ ] [How to verify]
- [ ] [Tests pass]

## Rollback
[How to undo]

Awaiting execution.
```

### Template 2: Execution → Review

```markdown
🤝 HANDOVER TO CLAUDE

## Execution Complete
[One sentence summary]

## Actions Taken
- [File changes]
- [Commands run]
- [Git operations]

## Test Results
[All tests with results]

## Issues Encountered
[Any deviations or problems]

## Items for Review
- [ ] [Specific areas needing review]

Awaiting review.
```

### Template 3: Review → Approval

```markdown
🤝 HANDOVER TO USER

## Review Complete
[One sentence summary]

## Strengths
- [What went well]

## Concerns
- [If any issues]

## Recommendation
[Approve / Request changes / Reject]

## Next Steps
[What should happen next]

Awaiting your decision.
```

---

## 🚨 ESCALATION

### When Handover Fails

If handover fails (no acknowledgment, confusion, errors):

1. **Immediate:** Stop and clarify
2. **Document:** What went wrong?
3. **Retry:** Attempt handover again with more detail
4. **Escalate:** After 2 failed attempts, notify user

**Escalation Template:**
```
⚠️ HANDOVER FAILED

Attempted handover from [AI A] to [AI B] has failed twice.

Issue: [Description of problem]
Attempts: [What was tried]
Blocker: [What's preventing handover]

USER INPUT REQUIRED:
[Specific question or decision needed]
```

---

## 📈 MEASURING HANDOVER EFFECTIVENESS

Track these metrics:

| Metric | Target | How to Measure |
|--------|--------|----------------|
| **Successful handovers** | >95% | Count completed without retry |
| **Handover clarity** | >90% | Receiving AI understands immediately |
| **Handover completeness** | 100% | No missing information |
| **Acknowledgment rate** | 100% | All handovers acknowledged |
| **Circular handovers** | 0 | Track A→B→A patterns |
| **User escalations** | <5% | Handovers needing user help |

---

## 🔗 RELATED DOCUMENTS

- **GLOBAL_AI_RULES.md** - RULE 12 (role separation)
- **ERROR_HANDLING_PROTOCOL.md** - Error routing
- **DEFINITION_OF_DONE.md** - Completion criteria
- **PROJECT_DECISION_MATRIX.md** - Decision handovers

---

## 💡 BEST PRACTICES

### DO
✅ **Be explicit** - Use clear handover statements  
✅ **Be complete** - Provide all context needed  
✅ **Be specific** - File paths, commands, criteria  
✅ **Acknowledge** - Confirm receipt and understanding  
✅ **Verify** - Check work before handing over  
✅ **Document** - Log handovers for audit  

### DON'T
❌ **Assume** - Don't assume other AI knows context  
❌ **Skip** - Don't skip handover steps  
❌ **Cross roles** - Don't do work outside your role  
❌ **Ghost** - Don't hand over without confirmation  
❌ **Repeat** - Don't loop indefinitely  

---

## 🎓 TRAINING

### For Claude
- Always complete design before handover
- Provide complete implementation instructions
- Never execute commands
- Review Warp's work thoroughly
- Approve or request specific changes

### For Warp
- Wait for complete handover from Claude
- Execute exactly as designed
- Document all actions taken
- Report issues immediately
- Hand back for review, don't self-approve

### For Users
- Recognize when handover is happening
- Allow AIs to complete their phases
- Intervene only when escalated
- Provide clarifications when asked

---

## ✅ QUICK REFERENCE

**Handover Trigger:** Claude finished design OR Warp finished execution  
**Handover Statement:** "🤝 HANDOVER TO [AI]"  
**Acknowledgment:** "✅ HANDOVER RECEIVED FROM [AI]"  
**Template Location:** See "Handover Templates" section above  
**Escalation:** After 2 failed attempts, notify user  

---

**Remember:** Clean handovers = efficient collaboration. Take the extra 30 seconds to do it right.

---

**Document Owner:** AI Governance Lead  
**Version:** 1.0.0  
**Last Updated:** 2026-01-12  
**Next Review:** 2026-04-12  

**Co-Authored-By: Warp <agent@warp.dev>**
