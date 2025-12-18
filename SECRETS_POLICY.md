# SECRETS_POLICY.md

**Version:** 1.0.0  
**Last Updated:** 2025-12-18  
**Status:** Foundation Document  
**Governance Rule:** Implements RULE 12-15 (Strict Role Separation) - Secret Handling

---

## Purpose

This document defines where secrets are stored, how they are handled, and the policies governing their use across the AI governance framework. **This document contains NO secret values** - only locations, patterns, and procedures.

**Critical Principle:** Secrets must never appear in Git repositories, logs, chat history, or any persistent storage except designated secret stores.

---

## 1. Secret Storage Locations

### Primary Secret Stores

#### User Environment File
**Location:** `C:\Users\bermi\.env`  
**Purpose:** Working API keys for active development  
**Access:** User profile only  
**Contents:** Active credentials for AI services, APIs, and tools

**Known Keys (names only):**
- `ANTHROPIC_API_KEY`
- `OPENAI_API_KEY`
- `ELEVENLABS_API_KEY`
- `SERPAPI_API_KEY`
- `NOTION_API_KEY`

**Management:**
- Primary location for Claude-related API keys
- Used by terminal sessions and development tools
- Should be loaded via PowerShell profile or shell startup

---

#### Tools Environment File
**Location:** `C:\tools\.env`  
**Purpose:** Shared API keys for system-wide tools  
**Access:** System-wide (all users with access to C:\tools\)  
**Contents:** n8n credentials, shared service API keys

**Known Keys (names only):**
- `N8N_API_KEY`
- Shared service credentials (exact keys need verification)

**Management:**
- Used by n8n and other shared automation tools
- May be sourced by system-level processes
- Coordinate changes with n8n workflow dependencies

⚠️ **Needs verification:** Complete inventory of keys in C:\tools\.env

---

#### n8n Credentials Vault
**Location:** n8n instance at http://192.168.50.246:5678  
**Purpose:** Secure storage for workflow credentials  
**Access:** Via n8n web UI or API (requires N8N_API_KEY)  
**Contents:** OAuth tokens, API keys, database credentials used by workflows

**Known Credential Types:**
- Google service account credentials
- Google OAuth (Client ID/Secret)
- External API credentials
- Database connection strings

**Management:**
- Accessed through n8n web interface
- Used by workflow nodes automatically
- Cannot be extracted programmatically (black box)
- Must be managed through n8n UI only

---

#### Project-Specific Environment Files
**Location Pattern:** `C:\Users\bermi\Projects\{project-name}\.env`  
**Purpose:** Project-specific credentials and configuration  
**Access:** Project scope only  
**Contents:** API keys, tokens, and secrets specific to individual projects

**Management:**
- Each project may have its own .env file
- Should be listed in .gitignore
- Should not duplicate keys from global .env files
- Use for project-specific secrets only

**Known Projects with .env files:**
- (Exact list needs inventory verification)

⚠️ **Needs verification:** Complete inventory of project-specific .env files

---

### Environment Variable Loading

**PowerShell Pattern:**
```powershell
# Load from .env file (do not display values)
Get-Content C:\Users\bermi\.env | ForEach-Object {
    if ($_ -match '^([^=]+)=(.+)$') {
        [Environment]::SetEnvironmentVariable($matches[1], $matches[2], 'Process')
    }
}
```

**Node.js Pattern:**
```javascript
// Use dotenv package
require('dotenv').config({ path: 'C:\\Users\\bermi\\.env' });
// Access via process.env.KEY_NAME
```

**Python Pattern:**
```python
# Use python-dotenv package
from dotenv import load_dotenv
load_dotenv('C:\\Users\\bermi\\.env')
# Access via os.getenv('KEY_NAME')
```

---

## 2. Secret Naming Conventions

### Observed Patterns

**API Keys:**
- Format: `{SERVICE}_API_KEY`
- Examples: `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, `NOTION_API_KEY`
- Convention: Uppercase with underscores

**Service Credentials:**
- Format: `{SERVICE}_{CREDENTIAL_TYPE}`
- Examples: `GOOGLE_SERVICE_ACCOUNT`, `GOOGLE_CLIENT_ID`
- Convention: Uppercase with underscores

**Tokens:**
- Format: `{SERVICE}_TOKEN` or `{SERVICE}_ACCESS_TOKEN`
- Examples: `GITHUB_TOKEN`, `N8N_API_KEY` (Note: n8n uses _KEY not _TOKEN)
- Convention: Uppercase with underscores

### Standard Naming Rules

**Must Follow:**
1. Always UPPERCASE
2. Use underscores (\_) as separators, never hyphens (-)
3. Start with service/provider name
4. End with credential type (KEY, TOKEN, SECRET, etc.)
5. Be descriptive enough to identify the credential's purpose

**Examples of Good Names:**
- `STRIPE_API_KEY` (clear service and type)
- `DATABASE_CONNECTION_STRING` (clear purpose)
- `SLACK_WEBHOOK_URL` (clear service and type)

**Examples of Poor Names:**
- `apikey` (no service identifier)
- `my-secret` (uses hyphens, lowercase)
- `KEY1` (no context)

---

### How to Identify Secrets in Code

**Secret Indicators:**
- Variable names matching `*_API_KEY`, `*_TOKEN`, `*_SECRET`, `*_PASSWORD`
- Long alphanumeric strings (20+ characters)
- Base64-encoded strings in configuration
- OAuth client IDs/secrets
- Connection strings with embedded credentials
- Private keys (PEM format)

**Non-Secrets (Safe to Commit):**
- Public API endpoints (URLs without credentials)
- Client IDs that are meant to be public
- Non-sensitive configuration values
- Example/placeholder values clearly marked as such
- Public keys (public/private key pairs)

---

## 3. Handling Rules

### NEVER Do These Things

❌ **NEVER commit secrets to Git repositories**
- Not in .env files
- Not in configuration files
- Not in code comments
- Not in commit messages
- Not even in "private" repositories

❌ **NEVER display secrets in logs or output**
- Not in console.log() statements
- Not in error messages
- Not in debug output
- Not in file operation results
- Mask secrets if logging is required: `API_KEY=***...***`

❌ **NEVER store secrets in chat history**
- Claude must not see secret values
- Warp must not display secrets in execution reports
- Use references like "the ANTHROPIC_API_KEY from .env" instead
- If secret is accidentally shared, rotate it immediately

❌ **NEVER hardcode secrets in source code**
- Not even temporarily for testing
- Not in example code
- Not in commented-out sections
- Always use environment variables

---

### How to Reference Secrets

**In Scripts:**
```powershell
# PowerShell - Reference by name, never by value
$apiKey = $env:ANTHROPIC_API_KEY
# Use $apiKey in API calls, never echo/write it
```

```javascript
// Node.js - Reference by name
const apiKey = process.env.ANTHROPIC_API_KEY;
// Use apiKey, never console.log() it
```

```python
# Python - Reference by name
import os
api_key = os.getenv('ANTHROPIC_API_KEY')
# Use api_key, never print() it
```

**In Documentation:**
- Refer to secrets by their environment variable name
- Example: "Configure your `OPENAI_API_KEY` in the .env file"
- Never include actual values in documentation

**In Terminal Commands:**
```powershell
# Correct: Compute secret in prior step, store as env var
$apiKey = (Get-Content C:\Users\bermi\.env | Select-String "ANTHROPIC_API_KEY").ToString().Split('=')[1]
# Then use $apiKey in subsequent commands

# WRONG: Never display or echo secrets
echo $env:ANTHROPIC_API_KEY  # DON'T DO THIS
```

---

### Exception: Test/Development Placeholders

**When to Use Placeholders:**
- Example configuration files (`.env.example`)
- Documentation examples
- Test scaffolding

**Placeholder Format:**
```bash
# .env.example
ANTHROPIC_API_KEY=your_anthropic_api_key_here
OPENAI_API_KEY=your_openai_api_key_here
N8N_API_KEY=your_n8n_api_key_here
```

**Requirements:**
- Must be obviously fake (e.g., "your_api_key_here")
- Must be in `.example` files, not working config files
- Must be documented as placeholders

---

## 4. Key Rotation Procedures

### When to Rotate Keys

**Mandatory Rotation:**
- Key is accidentally committed to Git (rotate immediately)
- Key is exposed in logs or chat history (rotate immediately)
- Key is shared with unauthorized party (rotate immediately)
- Key is suspected to be compromised (rotate immediately)

**Scheduled Rotation:**
- Every 90 days for high-security keys (e.g., ANTHROPIC_API_KEY, OPENAI_API_KEY)
- Every 180 days for medium-security keys (e.g., SERPAPI_API_KEY)
- Every 365 days for low-security keys (e.g., public API tokens)

**Triggered Rotation:**
- After employee/contractor offboarding
- After security incident
- After major system changes
- On request from service provider

⚠️ **Needs verification:** Specific rotation schedule preferences for each key type

---

### How to Rotate Keys

**Step 1: Generate New Key**
1. Log into service provider dashboard
2. Generate new API key/token
3. Copy new key to secure temporary location (not in Git)

**Step 2: Update All Locations**
1. Update `C:\Users\bermi\.env` with new key
2. Update `C:\tools\.env` if key exists there
3. Update n8n credentials vault via web UI
4. Update project-specific .env files if applicable

**Step 3: Test New Key**
1. Test in isolated environment first
2. Verify all dependent systems still function
3. Check all workflows using the key in n8n

**Step 4: Revoke Old Key**
1. Log into service provider dashboard
2. Revoke/delete old key
3. Confirm old key no longer works

**Step 5: Document Rotation**
1. Update SECRET_ROTATION_LOG.md (metadata only, no values)
2. Note: key name, rotation date, reason
3. Commit log to ai-governance repository

---

### Rotation Coordination

**Dependencies to Check:**
- n8n workflows using the key
- Scheduled tasks or cron jobs
- CI/CD pipelines (if any)
- External integrations
- Backup scripts

**Notification Required:**
- If key is shared across projects, notify all project owners
- If key is used by n8n, test all affected workflows
- If key is system-wide (C:\tools\.env), verify all system processes

---

## 5. Access Control

### Who/What Can Access Secrets

**Claude (AI System):**
- ❌ Cannot access secret values
- ✅ Can reference secrets by name in designs
- ✅ Can specify which secrets are needed for a task
- ❌ Cannot read .env files directly
- ❌ Cannot access n8n credentials vault

**Warp (Execution System):**
- ✅ Can read environment variables in execution context
- ✅ Can load .env files to set environment variables
- ❌ Cannot display secret values in output/logs
- ✅ Can use secrets in API calls (without logging them)
- ❌ Cannot commit secrets to Git

**User (Human):**
- ✅ Full access to all secret stores
- ✅ Can view, edit, and rotate secrets
- ✅ Can grant/revoke access to secrets
- ✅ Responsible for secret creation and deletion

**n8n (Workflow System):**
- ✅ Can access its own credentials vault
- ✅ Can use secrets in workflow execution
- ❌ Cannot expose secrets via API responses
- ✅ Can be granted access to specific credentials via vault

---

### Credential Vault Permissions

**n8n Credentials Vault:**
- Access controlled by n8n user authentication
- Credentials are workflow-scoped or global
- No programmatic extraction of credentials
- Manage only via n8n web UI at http://192.168.50.246:5678

**Permission Levels:**
- **Owner:** Can create, read, update, delete credentials
- **User:** Can use credentials in workflows, cannot view values
- **None:** Cannot access credentials

⚠️ **Needs verification:** n8n user accounts and their permission levels

---

### Environment File Permissions

**File System Permissions:**
- `.env` files should be readable only by the user who needs them
- C:\Users\bermi\.env: User profile only
- C:\tools\.env: System-wide (needs evaluation)
- Project .env files: Project scope only

**Recommended Permissions:**
```powershell
# Set restrictive permissions on .env files
icacls "C:\Users\bermi\.env" /inheritance:r
icacls "C:\Users\bermi\.env" /grant:r "$env:USERNAME:(R)"
```

⚠️ **Needs verification:** Current permissions on .env files and whether they meet security requirements

---

## 6. Secret Discovery

### How to Find Where a Secret is Stored

**Step 1: Check Common Locations**
1. `C:\Users\bermi\.env` (primary user secrets)
2. `C:\tools\.env` (shared/system secrets)
3. n8n credentials vault (workflow secrets)
4. Project-specific .env files

**Step 2: Search by Key Name**
```powershell
# Search for key name in .env files
Get-ChildItem -Path C:\Users\bermi\Projects\ -Recurse -Filter ".env" | 
    ForEach-Object { 
        Select-String -Path $_.FullName -Pattern "KEY_NAME" 
    }
```

**Step 3: Check n8n Credentials**
1. Log into http://192.168.50.246:5678
2. Navigate to Credentials section
3. Search by credential name or type

**Step 4: Check Documentation**
1. Review project README files
2. Check WARP.md files for secret references
3. Look for .env.example files

---

### What to Do if Secret Location is Unknown

**If Claude needs a secret for a design:**
1. Claude specifies which secret is needed (by name)
2. Claude includes in WARP.md: "Load {SECRET_NAME} from environment"
3. Warp attempts to load from standard locations
4. Warp reports if secret is not found
5. User locates or creates secret as needed

**If Warp encounters missing secret during execution:**
1. Warp reports: "Secret {NAME} not found in environment"
2. Warp stops execution at that point
3. Warp hands back to Claude/user for guidance
4. User locates secret or provides it
5. Warp resumes after secret is available

**If secret needs to be created:**
1. User generates secret from service provider
2. User adds to appropriate .env file
3. User confirms location for documentation
4. Execution resumes

---

### Emergency Procedures for Compromised Secrets

**Immediate Actions (within 1 hour):**
1. **STOP all systems** using the compromised secret
2. **ROTATE the key** at service provider immediately
3. **UPDATE all locations** with new key
4. **REVOKE old key** at service provider
5. **VERIFY** old key no longer works

**Investigation (within 24 hours):**
1. Determine how secret was compromised
2. Identify what systems/data were exposed
3. Check service provider logs for unauthorized usage
4. Document incident in SECRET_ROTATION_LOG.md

**Follow-up (within 1 week):**
1. Review and update this secrets policy if needed
2. Implement additional safeguards if applicable
3. Notify affected parties if required
4. Complete post-incident review

**Escalation:**
- If compromise involves payment/financial keys → contact finance/billing immediately
- If compromise involves user data → follow data breach procedures
- If compromise involves multiple keys → perform full security audit

---

## 7. Git Safety Mechanisms

### Pre-Commit Protections

**Required .gitignore patterns:**
```gitignore
# Environment files
.env
.env.*
!.env.example

# Secret stores
secrets/
credentials/
*.key
*.pem
*.p12

# Configuration with secrets
config/local.*
config/*.local.*
```

**Pre-commit Hook (recommended):**
```bash
#!/bin/sh
# Check for potential secrets before commit
if git diff --cached | grep -E "(API_KEY|TOKEN|SECRET|PASSWORD)" | grep -v "example"; then
    echo "ERROR: Potential secret detected in commit"
    echo "Review your changes and remove any secrets"
    exit 1
fi
```

⚠️ **Needs verification:** Whether pre-commit hooks are currently in place

---

### If Secret is Accidentally Committed

**DO NOT JUST DELETE THE FILE IN A NEW COMMIT**
- The secret is still in Git history
- The secret must be considered compromised

**Correct Procedure:**
1. **ROTATE the key immediately** (see Section 4)
2. **Remove from Git history** using one of these methods:
   ```bash
   # Option 1: BFG Repo-Cleaner (recommended)
   bfg --replace-text secrets.txt repo.git
   
   # Option 2: git filter-branch (more manual)
   git filter-branch --force --index-filter \
     'git rm --cached --ignore-unmatch path/to/file' \
     --prune-empty --tag-name-filter cat -- --all
   ```
3. **Force push** to remote (if already pushed)
4. **Notify collaborators** to re-clone repository
5. **Document incident** in SECRET_ROTATION_LOG.md

---

## 8. Secret Documentation

### What to Document (in this repository)

**DO document:**
- Secret names (e.g., ANTHROPIC_API_KEY)
- Storage locations (e.g., C:\Users\bermi\.env)
- Purpose of each secret (e.g., "Claude API access")
- Rotation schedule
- Rotation history (dates only, no values)
- Dependencies (which systems use which secrets)

**DO NOT document:**
- Actual secret values
- Partial secret values
- Hints about secret values
- Secret generation methods that could aid guessing

---

### SECRET_ROTATION_LOG.md Template

```markdown
# Secret Rotation Log

| Secret Name | Last Rotated | Reason | Next Rotation Due | Rotated By |
|-------------|--------------|--------|-------------------|------------|
| ANTHROPIC_API_KEY | 2025-12-18 | Initial setup | 2026-03-18 | User |
| OPENAI_API_KEY | 2025-12-18 | Initial setup | 2026-03-18 | User |

## Rotation Notes

### 2025-12-18: Initial Setup
- Established initial secret storage locations
- Created this rotation log
- Set 90-day rotation schedule for AI service keys
```

**Location:** `C:\Users\bermi\Projects\ai-governance\SECRET_ROTATION_LOG.md`

⚠️ **Needs verification:** Create SECRET_ROTATION_LOG.md during governance repository setup

---

## 9. Integration with Governance Framework

### WARP.md Secret References

**When Claude designs a WARP.md handover that requires secrets:**

```markdown
## Prerequisites
- Required secrets: ANTHROPIC_API_KEY, NOTION_API_KEY
- Load from: C:\Users\bermi\.env
- Verification: Confirm secrets are available before execution

## Step 3: Execute API Call
```powershell
# Load environment variables (do not display)
# Use $env:ANTHROPIC_API_KEY in API call
# Do not log or output the key value
```
```

**Warp's responsibilities:**
- Load secrets from specified location
- Use secrets in execution without displaying them
- Report "secret not found" if missing, not "invalid value"
- Never include secret values in execution reports

---

### Audit Requirements

**Regular Secret Audits:**
- Frequency: Quarterly
- Check: All secrets are documented
- Check: All secrets are in designated storage locations
- Check: No secrets in Git history
- Check: Rotation schedule is being followed

**Audit Checklist:**
- [ ] All secrets in C:\Users\bermi\.env are documented
- [ ] All secrets in C:\tools\.env are documented
- [ ] No .env files are committed to Git
- [ ] .gitignore patterns are in place
- [ ] Rotation log is up to date
- [ ] No orphaned secrets exist
- [ ] All secrets have known owners/purposes

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2025-12-18 | Initial foundation document | Claude (designed) / Warp (committed) |

---

**Next Review Date:** 2025-01-18  
**Document Owner:** ai-governance repository  
**Governance Rule:** RULE 12-15 (Strict Role Separation) - Secret Handling