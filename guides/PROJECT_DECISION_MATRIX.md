# PROJECT DECISION MATRIX
**When to Create New Repo vs Extend Existing - Decision Framework**

**Version:** 1.0.0  
**Last Updated:** 2026-01-12  
**Owner:** Primary System Administrator  
**Review Schedule:** Monthly (or before any new project)

---

## 🎯 PURPOSE

This guide prevents duplicate work by providing a systematic decision-making process for:
- ✅ Determining if a new repository is needed
- ✅ Identifying existing repositories that can be extended
- ✅ Evaluating the cost/benefit of new vs extend
- ✅ Ensuring alignment with existing infrastructure

**MANDATORY:** All AIs (Claude, Warp, GPT, etc.) MUST use this matrix before creating any new project.

---

## 📊 DECISION FLOWCHART

```
START: New Project Idea
    ↓
[1] SEARCH EXISTING (Step 1)
    ↓
    Does capability exist? ────YES───→ [2] ASSESS EXTENSION (Step 2)
    ↓ NO                                        ↓
[3] EVALUATE INTEGRATION (Step 3)         Can extend existing?
    ↓                                           ↓ YES        ↓ NO
    Overlaps with existing? ──YES──→ [4] COST-BENEFIT (Step 4)  ↓
    ↓ NO                                   ↓                     ↓
[5] JUSTIFY NEW REPO (Step 5)         Score ≥ 7? ────YES───→ EXTEND EXISTING
    ↓                                      ↓ NO                  ↓
    Passes criteria? ──YES──→ CREATE NEW REPO              Document decision
    ↓ NO                         ↓                          Push to GitHub
    REJECT/DEFER              Document decision             Update registry
                              Push to GitHub
                              Update registry
```

---

## 🔍 STEP 1: SEARCH EXISTING REPOSITORIES

**Before anything else, search for existing solutions.**

### 1.1 Check PROJECT_REGISTRY.md
Location: `C:\Users\bermi\Projects\PROJECT_REGISTRY.md`

```powershell
# Read the registry
Get-Content C:\Users\bermi\Projects\PROJECT_REGISTRY.md | Select-String -Pattern "keyword"
```

### 1.2 Query GitHub Repositories
```powershell
# List all repos with descriptions
gh repo list bermingham85 --limit 100 --json name,description
```

### 1.3 Search by Capability
Use these categories from the registry:

| Category | Check These Repos |
|----------|-------------------|
| **Agent Systems** | agent-agency-mcp, openai-notion-mcp, auto-agent-creator |
| **Orchestration** | ai-orchestrator-platform, ai-orchestrator, orchestrator |
| **Workflows** | bermech-n8n-workflows, hourly-autopilot-system |
| **Analysis/Search** | CHAT_ANALYZER_MASTER |
| **Content Creation** | AutoDesign-POD-Empire, ComfyUI, midjourney-news-automation, gremlos-world-puppet |
| **Business Automation** | lm-cleaning-booking, brand-launchpad-service, balding-pig-automation |
| **MCP Servers** | chatgpt-mcp-server, n8n-mcp, openai-notion-mcp |

### 1.4 Search Code
```powershell
# Search across all local repos
Get-ChildItem C:\Users\bermi\Projects -Recurse -Include *.md,*.json,package.json,README.md | 
    Select-String -Pattern "your-keyword" | 
    Select-Object Path, Line
```

### 1.5 Check MCP Integration
- Does n8n have a workflow for this? http://192.168.50.246:5678
- Can this be an MCP tool instead of a repo?
- Is this already in agent-agency-mcp capabilities?

**RESULT:** If capability exists → Go to Step 2. If not → Go to Step 3.

---

## 🔧 STEP 2: ASSESS EXTENSION FEASIBILITY

**An existing repo was found. Can it be extended?**

### 2.1 Extension Compatibility Checklist

Score each item (1 = poor fit, 5 = excellent fit):

| Criteria | Score (1-5) | Notes |
|----------|-------------|-------|
| **Technology Stack Match** | ___ | Same language/framework? |
| **Architectural Alignment** | ___ | Fits existing structure? |
| **Scope Overlap** | ___ | Related domain/purpose? |
| **Maintenance Burden** | ___ | Won't significantly complicate? |
| **Team Ownership** | ___ | Same maintainer/team? |
| **Deployment Model** | ___ | Same hosting/deployment? |
| **Data Model Compatibility** | ___ | Shared data structures? |
| **Security Boundary** | ___ | Same security requirements? |

**Scoring:**
- **32-40:** Excellent fit - EXTEND EXISTING
- **24-31:** Good fit - Likely extend, but review Step 4
- **16-23:** Moderate fit - Proceed to Step 4 (Cost-Benefit)
- **8-15:** Poor fit - Likely create new repo
- **<8:** Very poor fit - CREATE NEW REPO

**If Score ≥ 24:** Skip to Step 6 (Extend Existing)  
**If Score < 24:** Proceed to Step 4 (Cost-Benefit Analysis)

---

## 🔗 STEP 3: EVALUATE INTEGRATION OPPORTUNITIES

**No exact match found. Can this integrate with existing infrastructure?**

### 3.1 Integration Points Checklist

Check all that apply:

- [ ] **Uses n8n workflows** → Add to bermech-n8n-workflows
- [ ] **Extends MCP capabilities** → Add to agent-agency-mcp or relevant MCP server
- [ ] **Adds AI orchestration features** → Extend ai-orchestrator-platform
- [ ] **Provides data/analysis** → Could be a service in CHAT_ANALYZER_MASTER
- [ ] **Content generation** → Fits with ComfyUI/midjourney ecosystem
- [ ] **Business process** → Could be n8n workflow + existing services
- [ ] **API/Integration layer** → Could be middleware in existing orchestrator

### 3.2 Microservice vs Monolith Decision

| Choose Microservice (New Repo) If: | Choose Monolith (Extend) If: |
|------------------------------------|------------------------------|
| Independent scaling needed | Shared business logic |
| Different technology stack | Same deployment cycle |
| Separate team ownership | Tight coupling acceptable |
| Different release cadence | Shared data model |
| Bounded context is clear | Cross-cutting concerns |

**RESULT:** 
- If 3+ integration points checked → Consider extending existing
- If <2 integration points → Likely needs new repo → Go to Step 5

---

## 💰 STEP 4: COST-BENEFIT ANALYSIS

**Compare the costs of extending vs creating new.**

### 4.1 Cost Comparison Matrix

| Factor | Extend Existing | Create New | Winner |
|--------|-----------------|------------|--------|
| **Development Time** | Hours to modify | Days to scaffold | Usually Extend |
| **Cognitive Load** | Learn existing code | Clean slate | Depends on complexity |
| **Technical Debt** | May increase if poor fit | Starts clean | Depends on fit |
| **Maintenance** | One repo to maintain | +1 repo to maintain | Extend |
| **Deployment** | Existing pipeline | New CI/CD setup | Extend |
| **Documentation** | Update existing | Create from scratch | Extend |
| **Testing** | May affect existing tests | Independent tests | New |
| **Dependencies** | Shared vulnerabilities | Isolated dependencies | New |
| **Discovery** | Harder to find in large repo | Easier with dedicated repo | New |
| **Versioning** | Coupled releases | Independent releases | New |

### 4.2 Risk Assessment

**Risks of Extending:**
- Breaking existing functionality
- Increased complexity in single codebase
- Slower development due to existing constraints
- Merge conflicts with other features

**Risks of Creating New:**
- Duplicate functionality
- Integration complexity
- More maintenance overhead
- Harder to share code/types
- Additional deployment infrastructure

### 4.3 Decision Score

Calculate total score:

**Extend Points (+):**
- Same tech stack: +3
- Tight integration needed: +3
- Same deployment model: +2
- Shared team: +2
- Related domain: +2
- Simple addition: +2
- Frequent cross-repo changes expected: +2

**New Repo Points (+):**
- Different tech stack: +3
- Independent scaling: +3
- Different team: +2
- Separate release cycle: +2
- Bounded context: +2
- Greenfield benefits: +1
- Clear API boundary: +2

**Total Score:**
- Extend Points: ___
- New Repo Points: ___

**Decision:**
- **Extend wins by ≥3 points** → EXTEND EXISTING (Go to Step 6)
- **New wins by ≥3 points** → CREATE NEW REPO (Go to Step 5)
- **Tie or <3 difference** → Escalate for human decision

---

## ✅ STEP 5: JUSTIFY NEW REPOSITORY

**All checks suggest a new repo is needed. Final validation.**

### 5.1 New Repository Justification Checklist

Answer all questions. Must have ≥6 "YES" answers to proceed.

| # | Question | YES/NO |
|---|----------|--------|
| 1 | **Does this solve a problem not addressed by existing repos?** | ___ |
| 2 | **Would extending existing repos significantly increase complexity?** | ___ |
| 3 | **Does this have a clear, bounded domain/context?** | ___ |
| 4 | **Will this be maintained independently?** | ___ |
| 5 | **Does this warrant its own deployment/scaling strategy?** | ___ |
| 6 | **Is the scope large enough to justify separate repo overhead?** | ___ |
| 7 | **Will this have its own release cycle?** | ___ |
| 8 | **Does this require different security/compliance requirements?** | ___ |
| 9 | **Will multiple other projects depend on this?** | ___ |
| 10 | **Is this experimental/POC that might be deprecated?** | ___ |

**Score: ___ / 10**

**Decision Rules:**
- **8-10 YES:** Strong justification - CREATE NEW REPO
- **6-7 YES:** Moderate justification - CREATE NEW REPO (with monitoring)
- **4-5 YES:** Weak justification - RECONSIDER or extend existing
- **<4 YES:** Insufficient justification - DO NOT CREATE

### 5.2 Anti-Patterns to Avoid

❌ **DO NOT create a new repo if:**
- Only adds 1-2 new functions/endpoints
- Duplicates >50% of existing functionality
- Requires constant coordination with existing repos
- Could be a feature flag in existing repo
- Is just a refactor/reorganization of existing code
- Will be <100 lines of code
- Is a one-time script (put in existing `/scripts`)

### 5.3 Required Documentation

Before creating new repo, prepare:
- [ ] **README.md** with clear purpose and scope
- [ ] **Architecture Decision Record (ADR)** explaining why new repo
- [ ] **Integration plan** with existing systems
- [ ] **Maintenance plan** (who owns it?)
- [ ] **Deprecation criteria** (when to sunset?)

**RESULT:** If justified → CREATE NEW REPO (Go to Step 7)

---

## 🛠️ STEP 6: EXTEND EXISTING REPOSITORY

**Decision: Extend an existing repository.**

### 6.1 Extension Preparation

1. **Clone/Pull latest:**
   ```bash
   cd C:\Users\bermi\Projects\[repo-name]
   git pull origin main
   ```

2. **Create feature branch:**
   ```bash
   git checkout -b feature/[description]
   ```

3. **Review existing code:**
   - Understand current architecture
   - Identify extension points
   - Check for existing patterns to follow
   - Review tests

4. **Document extension plan:**
   - What files will change?
   - What new files/modules needed?
   - Impact on existing functionality?
   - Testing strategy?

### 6.2 Extension Best Practices

- ✅ Follow existing code style/conventions
- ✅ Add tests for new functionality
- ✅ Update README.md
- ✅ Add to CHANGELOG.md
- ✅ Update API documentation if applicable
- ✅ Run existing test suite (ensure no regressions)
- ✅ Create PR with clear description

### 6.3 Extension Template

Document in `extension-plan.md`:

```markdown
# Extension Plan: [Feature Name]

## Target Repository
- **Repo:** [repo-name]
- **Reason for extension:** [why extending vs new]

## Changes Required
- [ ] New files: [list]
- [ ] Modified files: [list]
- [ ] New dependencies: [list]

## Testing Plan
- [ ] Unit tests: [list]
- [ ] Integration tests: [list]
- [ ] Manual testing: [steps]

## Rollback Plan
- [How to revert if issues]

## Documentation Updates
- [ ] README.md
- [ ] API docs
- [ ] CHANGELOG.md
```

**RESULT:** Execute extension, test, commit, push, update PROJECT_REGISTRY.md

---

## 🆕 STEP 7: CREATE NEW REPOSITORY

**Decision: Create a new repository.**

### 7.1 Repository Creation Checklist

- [ ] **Name follows convention:** `[purpose]-[technology]` (e.g., `payment-processor-node`)
- [ ] **Description is clear:** One sentence explaining purpose
- [ ] **Visibility:** Public or Private? (default: Private initially)
- [ ] **License:** MIT (or appropriate for project)
- [ ] **gitignore:** Language-appropriate template
- [ ] **README:** Created from template

### 7.2 Create Repository

```powershell
# Create on GitHub
gh repo create bermingham85/[repo-name] --public --description "[description]" --gitignore Node

# Or via web UI: https://github.com/new
```

### 7.3 Initial Setup

```bash
# Clone locally
cd C:\Users\bermi\Projects
git clone https://github.com/bermingham85/[repo-name].git
cd [repo-name]

# Initialize project structure
# (language-specific: npm init, python -m venv, etc.)

# Create README from template
# Copy from: C:\Users\bermi\Projects\ai-governance\templates\README_TEMPLATE.md

# First commit
git add .
git commit -m "Initial commit: [purpose]

Co-Authored-By: Warp <agent@warp.dev>"
git push origin main
```

### 7.4 Integration Setup

Configure integrations:

- [ ] **Add to PROJECT_REGISTRY.md:**
  ```markdown
  | **[repo-name]** | `C:\Users\bermi\Projects\[repo-name]` | ✅ GitHub | ✅ Active | [purpose] |
  ```

- [ ] **Update capability registry** if applicable
- [ ] **Add to n8n workflows** if automation needed
- [ ] **Configure CI/CD** (GitHub Actions, etc.)
- [ ] **Add to monitoring/logging** if applicable
- [ ] **Document in ai-governance ADR:**
  ```
  C:\Users\bermi\Projects\ai-governance\adr\NNN-[repo-name].md
  ```

### 7.5 Required Files

Create these files in new repo:

1. **README.md** (from template)
2. **.gitignore** (language-specific)
3. **LICENSE** (MIT or appropriate)
4. **CHANGELOG.md** (version history)
5. **.github/workflows/ci.yml** (CI/CD pipeline)
6. **package.json** / **requirements.txt** / etc. (dependencies)
7. **tests/** directory (test files)

**RESULT:** New repo created, documented, integrated with ecosystem

---

## 📝 STEP 8: DOCUMENT DECISION

**Regardless of decision (extend or new), document it.**

### 8.1 Create Architecture Decision Record (ADR)

Location: `C:\Users\bermi\Projects\ai-governance\adr\`

Template:
```markdown
# ADR-[NNN]: [Decision Title]

**Date:** YYYY-MM-DD
**Status:** Accepted
**Deciders:** [Who made the decision]

## Context
[What problem are we solving? What was the decision trigger?]

## Decision
[What did we decide? Extend [repo-name] OR Create new repo [repo-name]]

## Alternatives Considered
1. **Option 1:** [description] - Rejected because [reason]
2. **Option 2:** [description] - Rejected because [reason]

## Rationale
[Why did we choose this option? Reference decision matrix scores]

## Consequences
**Positive:**
- [benefit 1]
- [benefit 2]

**Negative:**
- [drawback 1]
- [drawback 2]

**Risks:**
- [risk 1 + mitigation]
- [risk 2 + mitigation]

## Implementation Notes
[Any special considerations for implementation]

## Related Decisions
- ADR-[NNN]: [related decision]
```

### 8.2 Update PROJECT_REGISTRY.md

Add entry to appropriate section:
```markdown
| **[repo-name]** | `C:\Users\bermi\Projects\[repo-name]` | ✅ GitHub | ✅ Active | [purpose] |
```

Update statistics section.

### 8.3 Commit Documentation

```bash
cd C:\Users\bermi\Projects\ai-governance
git add adr/ADR-[NNN]-*.md
git add PROJECT_REGISTRY.md
git commit -m "Document decision: [extend/create] for [feature]

- Decision matrix score: [X]
- Rationale: [brief]

Co-Authored-By: Warp <agent@warp.dev>"
git push origin main
```

---

## 🚨 ESCALATION CRITERIA

**Escalate to human decision if:**

1. **Tie Score:** Decision matrix shows <3 point difference
2. **High Risk:** Security, compliance, or architectural concerns
3. **Large Budget:** >40 hours of work estimated
4. **Strategic Impact:** Affects multiple teams or systems
5. **Uncertainty:** Unclear requirements or scope
6. **Disagreement:** AIs (Claude vs Warp) disagree on approach

**Escalation Process:**
1. Document all findings from Steps 1-5
2. Present decision matrix scores
3. Highlight key trade-offs
4. Request human decision
5. Document final decision in ADR

---

## 📊 METRICS & MONITORING

Track these metrics to improve the decision matrix:

| Metric | Target | How to Measure |
|--------|--------|----------------|
| **Duplicate Repos Created** | 0 | Manual audit quarterly |
| **Extend vs New Ratio** | 3:1 | Count decisions in ADRs |
| **Decision Reversal Rate** | <5% | Track repos that should have been merged |
| **Time to Decision** | <1 hour | Timestamp decision process |
| **Repos Deprecated <6mo** | <10% | Track short-lived repos |

**Review Process:** Quarterly review of all decisions, update matrix weights based on outcomes.

---

## 🔄 CONTINUOUS IMPROVEMENT

### When to Update This Matrix

- After 10 decisions (initial calibration)
- Quarterly (regular review)
- When new patterns emerge
- When decision led to significant rework
- When team structure changes

### Feedback Loop

Document in `C:\Users\bermi\Projects\ai-governance\lessons-learned\`:
- Decisions that worked well
- Decisions that led to problems
- Proposed improvements to matrix

---

## 📚 QUICK REFERENCE

### TL;DR Decision Tree

```
1. Search existing (PROJECT_REGISTRY.md + GitHub)
   └─ Found? ──YES─→ 2. Can extend? ──YES─→ EXTEND
                │                      └─NO─→ 4. Cost-Benefit
                └─NO─→ 3. Integration points?
                          └─ Many? ──YES─→ EXTEND
                                     └─NO─→ 5. Justify new
                                               └─ Valid? ──YES─→ CREATE NEW
                                                          └─NO─→ REJECT
```

### Key Questions

1. **Does this capability already exist?** → Search first
2. **Can existing repo be extended without major pain?** → Extend
3. **Is this a clear, bounded context?** → Maybe new
4. **Will this add significant value vs maintenance cost?** → Validate
5. **Is this justified per checklist?** → Document and decide

### Default Bias

**Default to EXTEND** unless:
- Different tech stack
- Independent scaling required
- Clear bounded context
- Extending would significantly complicate existing repo

---

## 📞 SUPPORT

**Questions about this matrix?**
- Review: `REQUIRED_GOVERNANCE_GUIDES.md`
- Check: Existing ADRs in `adr/`
- Ask: Primary System Administrator
- Reference: PROJECT_REGISTRY.md

**Tools:**
- GitHub CLI: `gh repo list bermingham85`
- Registry: `C:\Users\bermi\Projects\PROJECT_REGISTRY.md`
- MCP: agent-agency-mcp for agent operations

---

**Document Owner:** Primary System Administrator  
**Version:** 1.0.0  
**Last Updated:** 2026-01-12  
**Next Review:** 2026-02-12  
**Status:** ✅ Active - Mandatory for all new projects
