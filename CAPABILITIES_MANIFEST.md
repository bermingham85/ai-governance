# CAPABILITIES_MANIFEST.md

**Version:** 1.0.0  
**Last Updated:** 2025-12-18  
**Status:** Foundation Document  
**Governance Rule:** Implements RULE 12-15 (Strict Role Separation)

---

## Purpose

This document defines the authoritative capabilities and boundaries for each system in the AI governance framework. It establishes what each component can and cannot do, ensuring strict role separation and preventing capability creep.

**Key Principle:** No system may operate outside its defined capabilities without explicit governance document updates committed to GitHub.

---

## 1. Claude Capabilities

### What Claude CAN Do

**Design & Architecture:**
- Design system architectures and workflows
- Create project structures and file hierarchies
- Design data models and API interfaces
- Plan integration strategies between systems
- Architect governance frameworks and policies

**Review & Audit:**
- Review code for quality, security, and best practices
- Audit project structures for compliance
- Analyze logs and execution reports
- Validate WARP.md handover documents
- Assess architectural decisions and tradeoffs

**Documentation & Templates:**
- Write WARP.md handover documents
- Create prompt templates for other AI systems
- Author governance documentation
- Design README files and technical guides
- Generate API documentation templates

**Analysis & Planning:**
- Break down complex tasks into execution steps
- Identify dependencies and sequencing requirements
- Propose solutions to technical problems
- Evaluate multiple implementation approaches
- Create test plans and validation criteria

**Knowledge Work:**
- Answer technical questions
- Explain concepts and patterns
- Provide coding guidance and examples
- Research best practices and patterns
- Synthesize information from multiple sources

### What Claude CANNOT Do

**Execution Operations:**
- ❌ Execute shell commands or scripts
- ❌ Read or write files directly to disk
- ❌ Make Git commits or pushes
- ❌ Run tests or compile code
- ❌ Deploy applications or services
- ❌ Start or stop processes
- ❌ Modify system configurations
- ❌ Access or modify secrets/credentials

**Direct System Interaction:**
- ❌ Access file systems directly
- ❌ Make network requests (except via web_search tool)
- ❌ Interact with databases
- ❌ Call APIs (except for analysis/design purposes)
- ❌ Install packages or dependencies

**Repository Operations:**
- ❌ Clone repositories
- ❌ Create branches
- ❌ Merge code
- ❌ Tag releases
- ❌ Manage GitHub issues or PRs

### Claude Invocation Methods

**Status:** AVAILABLE

**Method 1: MCP Server (agent-agency-mcp)**
- **Path:** `C:\Users\bermi\Projects\agent-agency-mcp`
- **Protocol:** Model Context Protocol
- **Function:** Claude Desktop → n8n workflows
- **Verified:** Yes (active in Claude Desktop config)
- **Use Case:** Agent delegation, workflow automation
- **Limitations:** Requires n8n instance at http://192.168.50.246:5678

**Method 2: Handover Templates (Manual)**
- **Claude → Warp:** `ai-governance\prompts\handover_claude_to_warp.md`
- **Warp → Claude:** `ai-governance\prompts\handover_warp_to_claude_review.md`
- **Protocol:** Structured markdown handover
- **Verified:** Yes (templates exist and documented)
- **Use Case:** Design review, governance bootstrap, audit tasks
- **Limitations:** Manual process (copy/paste to Claude interface)

**Method 3: Direct API (Not Recommended)**
- **Status:** EXISTS (archived in LLMBridgework)
- **Function:** Direct Anthropic API calls
- **Use Case:** Fallback only if Methods 1-2 unavailable
- **Limitations:** Requires API key management, no MCP integration

⚠️ **Preferred Method:** Use Method 2 (Handover Templates) for governance tasks. Use Method 1 (MCP) for operational agent tasks.

### Claude's Role in the Workflow

1. **Receives requests** from users or handovers from Warp
2. **Designs solutions** with complete specifications
3. **Creates WARP.md** handover documents with execution instructions
4. **Hands off to Warp** for all execution tasks
5. **Reviews results** when Warp reports back completion

**Invocation from Warp:**
- Warp uses handover template from `prompts/handover_warp_to_claude_review.md`
- User manually submits handover to Claude Desktop
- Claude responds with review findings and revised handover (if needed)

---

## 2. Warp Capabilities

### What Warp CAN Do

**File Operations:**
- Read files from disk (within C:\Users\bermi\Projects\ scope)
- Write files to disk
- Move and rename files
- Delete files and directories
- Create directory structures
- Search file contents

**Command Execution:**
- Execute PowerShell commands
- Run shell scripts (bash, sh)
- Execute Node.js scripts
- Run Python scripts
- Compile code when instructed
- Run test suites

**Git Operations:**
- Clone repositories
- Create and switch branches
- Stage files (`git add`)
- Commit changes with messages
- Push commits to remote
- Pull latest changes
- Create tags
- Manage remotes

**Development Tasks:**
- Install npm packages
- Install Python packages (pip)
- Run build processes
- Execute test runners
- Start development servers
- Run linters and formatters

**System Operations:**
- Check process status
- Read environment variables
- Execute system utilities
- Perform file system scans
- Generate reports from execution

### What Warp CANNOT Do

**Design & Planning:**
- ❌ Design system architectures
- ❌ Invent new processes or workflows
- ❌ Make architectural decisions
- ❌ Create governance policies
- ❌ Decide on implementation approaches without instructions

**Autonomous Decisions:**
- ❌ Modify plans without explicit instructions
- ❌ Skip steps in WARP.md handovers
- ❌ Interpret ambiguous requirements independently
- ❌ Make judgment calls on technical tradeoffs

**Secret Management:**
- ❌ Commit secrets to Git repositories
- ❌ Display secret values in logs or output
- ❌ Create secrets without documented policy
- ❌ Share secrets across project boundaries without authorization

### Warp's Role in the Workflow

1. **Receives WARP.md** handover documents from Claude
2. **Executes instructions** step-by-step as specified
3. **Reports progress** and any errors encountered
4. **Completes handover** with execution summary
5. **Returns control** to Claude or user

---

## 3. GitHub Role

### GitHub as Source of Truth

**What GitHub Stores:**
- All governance documents (GLOBAL_AI_RULES.md, CAPABILITIES_MANIFEST.md, SECRETS_POLICY.md)
- WARP.md templates and project-specific handovers
- Prompt templates for AI systems
- Project source code and configurations
- Documentation and README files
- Architecture decision records

### GitHub Responsibilities

**Version Control:**
- Track all changes to governance documents
- Maintain commit history for audit trails
- Enable rollback to previous states
- Tag stable versions of governance rules

**Access Control:**
- Define who can commit to which repositories
- Protect main branches with review requirements
- Enforce commit message standards
- Manage repository permissions

**Truth Enforcement:**
- No governance change is valid without a GitHub commit
- No WARP.md template applies until committed
- No process modification takes effect until versioned

### What CANNOT Bypass GitHub

- Governance document changes
- WARP.md template updates
- Global rule modifications
- Secret policy changes
- Capability boundary adjustments
- Protected zone definitions

### GitHub Integration Points

**Repository:** `ai-governance`  
**Location:** `C:\Users\bermi\Projects\ai-governance`  
**Branch Strategy:** `main` for stable, `draft` for proposals  
**Commit Requirement:** All governance changes must be committed by Warp

---

## 4. Tool Ecosystem

### n8n Workflow Automation

**Instance:** http://192.168.50.246:5678  
**Purpose:** Workflow automation and API orchestration

**Capabilities:**
- Execute scheduled workflows
- Orchestrate multi-step automation
- Store credentials in secure vault
- Provide API endpoints for workflow triggers
- Integrate with external services (Google, Notion, APIs)

**Access:**
- Web UI at http://192.168.50.246:5678
- API access via N8N_API_KEY
- Credentials vault for secret storage

**Limitations:**
- Single instance only (do not create additional instances)
- Workflows must be version-controlled separately from n8n
- Credential vault is black box (no programmatic extraction)

⚠️ **Needs verification:** Backup strategy for n8n workflows and credentials

---

### MCP Servers

**Available Servers:**

1. **Context7** - Context management (needs verification of specific capabilities)
2. **GitHub** - Repository operations and issue management
3. **Memory** - Persistent memory across sessions
4. **Notion** - Notion API integration
5. **Playwright** - Browser automation
6. **Sequential thinking** - Extended reasoning capabilities
7. **filesystem** - File system operations
8. **n8n-mcp-docs** - n8n documentation access
9. **n8n-workflows-docs** - n8n workflow documentation

**MCP Integration Rules:**
- MCP servers extend Claude's read/analysis capabilities only
- MCP servers do NOT grant Claude execution capabilities
- Warp handles all file writes, even if MCP provides read access
- MCP memory should align with GitHub source of truth

⚠️ **Needs verification:** Complete capability mapping for Context7, Memory, and Sequential thinking servers

---

### Development Tools

**Node.js:**
- Version management via nvm or direct installation
- npm for package management
- Capabilities: Run scripts, install dependencies, execute Node programs

**Python:**
- Python 3.x environment
- pip for package management
- Capabilities: Run scripts, install dependencies, execute Python programs

**PowerShell:**
- Primary shell for Windows operations
- Script execution and system administration
- Capabilities: File operations, process management, system queries

**Git:**
- Version control operations
- Integration with GitHub remote repositories
- Capabilities: Clone, commit, push, pull, branch management

---

## 5. Protected Zones

### Absolute No-Access Zones

**Personal Content:**
- `C:\Users\bermi\Pictures\` (and all subdirectories)
- `C:\Users\bermi\Documents\Personal\` (if exists)
- `C:\Users\bermi\Videos\Personal\` (if exists)

**Photo Management:**
- Any directory containing family photos
- Photo library databases
- Image editing project files (outside Projects scope)

**Video Editing:**
- Fillmore project files
- Filmora project files
- Video rendering directories

**Why These Protections Exist:**
- Privacy: Personal photos and videos are sensitive
- Data integrity: Editing projects can be corrupted by file operations
- Irreversibility: Accidental deletion of personal content is catastrophic

### How to Handle Accidental Encounters

**If AI encounters protected content:**
1. **STOP immediately** - Do not read, analyze, or process
2. **Report the encounter** to the user
3. **Do not log file paths** or directory contents
4. **Do not suggest operations** on protected content
5. **Wait for user guidance** before proceeding

**If user requests operation on protected zone:**
1. **Refuse the request** politely but firmly
2. **Explain the protection policy**
3. **Suggest alternative approaches** if applicable
4. **Do not create workarounds** to access protected content

### Project Scope Boundary

**Authorized Scope:** `C:\Users\bermi\Projects\` (and subdirectories only)

**Operations outside this scope:**
- Require explicit user confirmation
- Must be documented in WARP.md handover
- Should trigger additional verification steps

⚠️ **Needs verification:** Complete list of protected directories (user may have additional zones)

---

## 6. Integration Boundaries

### Claude → Warp Handover

**Trigger:** Claude completes design/planning phase  
**Mechanism:** WARP.md document  
**Format:** Structured markdown with step-by-step instructions  

**Handover Must Include:**
- Clear objective statement
- Sequenced execution steps
- Expected outcomes for each step
- Error handling instructions
- Verification criteria for completion

**Warp Must:**
- Acknowledge receipt of handover
- Execute steps in specified order
- Report progress after each major step
- Report completion with summary

---

### Warp → Claude Handover

**Trigger:** Warp completes execution or encounters error  
**Mechanism:** Execution report  
**Format:** Summary of actions taken and results  

**Report Must Include:**
- What was executed
- Files created/modified
- Commands run
- Any errors or warnings
- Verification of expected outcomes

**Claude Must:**
- Review the execution report
- Validate expected outcomes
- Identify any issues or gaps
- Determine next steps or completion

---

### GitHub Synchronization Points

**Before Execution:**
- Warp pulls latest governance documents
- Warp validates instructions against current rules

**After Execution:**
- Warp commits all governance changes to GitHub
- Warp pushes commits to remote
- Warp confirms GitHub is updated

**On Conflict:**
- Warp reports conflict to user/Claude
- Conflict resolution happens before proceeding
- No automatic conflict resolution without guidance

---

### Error Handling Responsibilities

**Claude's Error Handling:**
- Analyze error reports from Warp
- Propose solutions or workarounds
- Update WARP.md instructions if needed
- Escalate to user if unresolvable

**Warp's Error Handling:**
- Capture error details (command, output, exit code)
- Report error context (what step, what was attempted)
- Do not attempt improvised solutions
- Stop execution and report to Claude/user

**User Escalation Triggers:**
- Protected zone access attempts
- Secrets exposure or security concerns
- Governance document conflicts
- Unclear instructions in WARP.md
- System-level permission errors

---

## 7. Capability Verification & Updates

### How to Verify Capabilities

**Process:**
1. Test capability in isolated environment
2. Document test results
3. Update this manifest with verified capability
4. Commit change to GitHub via Warp

**Evidence Required:**
- Command/action that was tested
- Expected behavior
- Actual behavior
- Any limitations discovered

### How to Request Capability Changes

**Process:**
1. User or Claude proposes capability change
2. Claude designs updated capability definition
3. Claude creates WARP.md to update this manifest
4. Warp executes update and commits to GitHub
5. Capability change takes effect after commit

**Not Allowed:**
- Ad-hoc capability grants during execution
- Temporary capability expansions
- Capability assumptions without documentation

---

## 8. Audit & Compliance

### Regular Capability Audits

**Frequency:** Monthly or after major system changes  
**Process:**
1. Review actual system usage vs. documented capabilities
2. Identify capability drift or undocumented actions
3. Update manifest to reflect reality or enforce boundaries
4. Commit changes to GitHub

### Compliance Checks

**Before Each Major Execution:**
- Warp verifies handover aligns with this manifest
- Warp confirms no protected zone violations
- Warp validates secret handling procedures

**After Each Major Execution:**
- Claude reviews execution report against this manifest
- Claude identifies any capability boundary violations
- Claude proposes manifest updates if needed

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2025-12-18 | Initial foundation document | Claude (designed) / Warp (committed) |

---

**Next Review Date:** 2025-01-18  
**Document Owner:** ai-governance repository  
**Governance Rule:** RULE 12-15 (Strict Role Separation)