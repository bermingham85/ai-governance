# WARP.md - [Project Name]

**Project Type:** [Python / Node / Go / n8n / Mixed]  
**Status:** [Active / Development / Maintenance]  
**Governance Version:** 1.0.0  
**Last Updated:** [YYYY-MM-DD]

---

## ⚠️ MANDATORY GOVERNANCE COMPLIANCE

This project operates under the governance framework:

**Required Reading:**
1. `C:\Users\bermi\Projects\ai-governance\GLOBAL_AI_RULES.md` (RULE 12-16)
2. `C:\Users\bermi\Projects\ai-governance\HANDOVER_PROTOCOL.md`

**Key Principles:**
- Claude designs, Warp executes, GitHub is source of truth
- All handovers follow HANDOVER_PROTOCOL.md format
- Errors follow RULE 16 (classify, route, max 2 attempts)
- Protected zones are off-limits

**Governance Override:**
User must explicitly state: "Skip governance for [reason] because [benefit]"

---

## Project Overview

**Description:**  
[Brief 1-2 sentence description of what this project does]

**Primary Purpose:**  
[What problem does this solve?]

**Key Technologies:**  
- [Technology 1]
- [Technology 2]
- [Technology 3]

---

## Project-Specific Rules

### Development Environment
**Package Manager:** [uv / npm / yarn / go mod / etc.]  
**Python Version:** [if applicable]  
**Node Version:** [if applicable]  

**Installation:**
```bash
[Installation command]
```

**Testing:**
```bash
[Test command]
```

**Linting/Formatting:**
```bash
[Lint command]
[Format command]
```

---

### Code Standards

**Style Guide:**
- [Specific style requirements]
- [Naming conventions]
- [File organization]

**Type Safety:**
- [Type hint requirements]
- [Strictness level]

**Documentation:**
- [Docstring requirements]
- [Comment standards]

**Max Line Length:** [80 / 100 / 120]

---

### Git Workflow

**Branch Strategy:**
- `main` - [description]
- `develop` - [description]
- Feature branches: `feature/description`

**Commit Message Format:**
```
[type]: [subject]

[optional body]

[trailers if needed]
Co-Authored-By: Warp <agent@warp.dev>
```

**Commit Types:**
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation only
- `refactor:` - Code restructuring
- `test:` - Test additions/changes
- `chore:` - Maintenance tasks

**Trailers:**
- Bug fixes: `Reported-by: <name>`
- GitHub issues: `Github-Issue: #<number>`

---

## Protected Zones

### Project-Specific Protections
**Do NOT modify without explicit approval:**
- [Critical file 1]
- [Critical file 2]
- [Production configs]

**Require user review before:**
- [Database migrations]
- [API changes]
- [Breaking changes]

---

## Dependencies & External Services

### Required Services
| Service | Purpose | Endpoint |
|---------|---------|----------|
| [Service 1] | [Purpose] | [URL/location] |
| n8n | [If used] | http://192.168.50.246:5678 |

### API Keys / Secrets
**Location:** [.env / environment variables / secrets manager]  
**Documentation:** See `C:\Users\bermi\Projects\ai-governance\SECRETS_REGISTRY.md`

**Never commit:**
- `.env` files
- API keys
- Credentials
- Personal data

---

## Testing Requirements

### Test Coverage
**Required for:**
- All new features
- All bug fixes
- Public API changes
- Critical path functions

**Test Types:**
- Unit tests: [location/command]
- Integration tests: [location/command]
- E2E tests: [location/command if applicable]

**Test Framework:** [pytest / jest / go test / etc.]

**Async Testing:** [anyio / async/await patterns]

---

## Build & Deployment

### Local Development
```bash
[Setup commands]
```

### Build Process
```bash
[Build commands]
```

### Deployment
**Method:** [Docker / Manual / CI/CD / n8n workflow]  
**Target:** [Production location]  
**Requires:** [Permissions / approvals needed]

---

## Common Tasks

### Adding a New Feature
1. Create feature branch from `main`
2. [Implementation steps]
3. Add tests
4. Run linting/formatting
5. Create PR with detailed description
6. Wait for review

### Fixing a Bug
1. Create fix branch
2. Write failing test first (if possible)
3. Implement fix
4. Verify test passes
5. Add `Reported-by:` trailer if applicable
6. Create PR

### Updating Dependencies
1. [Update command]
2. Run full test suite
3. Check for breaking changes
4. Update documentation if needed
5. Commit with `chore:` prefix

---

## Error Handling (RULE 16 Compliance)

### When Warp Encounters Error
1. STOP at failed step
2. Classify error type (A-E)
3. Log in `ERROR_LOG.md` if non-trivial
4. Route to appropriate platform:
   - **Type A (Build/Runtime)** → Retry in Warp (max 2 attempts) → Escalate to Claude
   - **Type B (Logic/Architecture)** → Hand to Claude immediately
   - **Type D (Integration)** → Diagnose in Warp → Research if needed
   - **Type E (Knowledge)** → Research → Document → Resolve

### Error Log
**Location:** `./ERROR_LOG.md`  
**Template:** `C:\Users\bermi\Projects\ai-governance\templates\ERROR_LOG.md`

---

## Project Contacts

**Owner:** [Name/Role]  
**Repository:** [GitHub URL]  
**Documentation:** [Wiki/Docs location]  
**Issues:** [Issue tracker URL]

---

## Inheritance & References

**Inherits From:**
- Global Rules: `ai-governance\GLOBAL_AI_RULES.md`
- Handover Protocol: `ai-governance\HANDOVER_PROTOCOL.md`
- Platform Rules: `orchestrator\platforms\warp.md`
- [Project-specific template if applicable]

**Overrides:**
[Any exceptions to global rules - requires explicit justification]

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | [YYYY-MM-DD] | Initial project setup | [Name] |

---

**Next Review Date:** [YYYY-MM-DD]  
**Template Version:** 1.0.0  
**Governance Compliant:** ✅

---

**Co-Authored-By: Warp <agent@warp.dev>**
