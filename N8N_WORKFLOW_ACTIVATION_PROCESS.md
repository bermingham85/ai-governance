# n8n Workflow Activation Process

## Current State (2026-01-09)

### Problem Identified
- **n8n API limitations**: The `/api/v1/workflows` endpoint allows workflow creation (POST) but activation via PATCH/PUT is unreliable
- **Root cause**: n8n API has strict validation that rejects the `active` field in many contexts
- **Warp's approach**: Attempted multiple times to use REST API directly, resulted in duplicate workflows without activation

### What Works
✅ **Workflow Creation**: `POST /api/v1/workflows` successfully creates workflows
✅ **Workflow Retrieval**: `GET /api/v1/workflows` and `GET /api/v1/workflows/{id}` work reliably  
❌ **Workflow Activation via API**: PATCH/PUT with `{active: true}` fails with "method not allowed" or "read-only field" errors

### Correct Approach Going Forward

#### Option 1: Manual Activation (Current Required Method)
1. Create workflow via API
2. Provide user with direct link: `http://localhost:5678/workflow/{id}`
3. User toggles "Active" switch in top-right of n8n UI
4. Continue with testing/execution

#### Option 2: Use n8n-MCP Server (Recommended for Future)
The `czlonkowski/n8n-mcp` project provides a proper MCP interface for n8n:
- **GitHub**: https://github.com/czlonkowski/n8n-mcp
- **Setup**: Add to Claude Desktop or Warp MCP configuration
- **Tools Available**:
  - `n8n_create_workflow` - Create workflows
  - `n8n_update_partial_workflow` - Update workflow settings including activation
  - `n8n_list_workflows` - List workflows
  - `n8n_validate_workflow` - Validate workflows
  - And 20+ other n8n management tools

**Configuration for Warp**:
```json
{
  "mcpServers": {
    "n8n-mcp": {
      "command": "npx",
      "args": ["n8n-mcp"],
      "env": {
        "MCP_MODE": "stdio",
        "LOG_LEVEL": "error",
        "DISABLE_CONSOLE_OUTPUT": "true",
        "N8N_API_URL": "http://localhost:5678",
        "N8N_API_KEY": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyZjA1MzhkNS0zODJjLTRlYTMtYTMxZC1mNjkwZWY3ZWUzMGUiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzY4MDAxMDM4fQ.CsBAYnIYqulSVoJMAtvaNH7cDsfri38rs-hLRiNcoZI"
      }
    }
  }
}
```

**Usage Example**:
```typescript
// Activate workflow using n8n-MCP
await n8n_update_partial_workflow({
  id: 'workflow-id',
  operations: [{
    type: 'updateSettings',
    settings: { active: true }
  }]
});
```

#### Option 3: Direct Database Manipulation (Not Recommended)
```sql
-- Only use if absolutely necessary and you have direct DB access
UPDATE workflow_entity SET active = true WHERE id = 'workflow-id';
```

## GitHub Repository Creation

### What Works
✅ **GitHub API/CLI**: Both work reliably for all operations
- Use `gh` CLI: `gh repo create <name> --public --source=.`
- Use GitHub MCP if available
- Use REST API directly as fallback

### Process
1. Create repo
2. Initialize if needed
3. Push code
4. Set settings (description, topics, etc.)
5. Configure branch protection if needed

**No issues encountered** - GitHub operations are straightforward.

## Key Learnings for Future Sessions

### When Creating n8n Workflows:
1. **Check for existing workflow first** before creating (avoid duplicates)
2. **Don't retry creation on activation failure** - creation likely succeeded
3. **Provide manual activation link immediately** after creation
4. **Use n8n-MCP if available** instead of raw API calls
5. **Document the limitation** clearly to user

### Process Flow:
```
1. Check if n8n-MCP is available
   ├─ YES → Use n8n-MCP tools (handles activation properly)
   └─ NO  → Use REST API for creation only
           └─ Provide manual activation link
           └─ Wait for user confirmation
           └─ Test webhook/functionality
```

## Environment Configuration

### Critical Settings
- **n8n URL**: `http://localhost:5678` (NOT 192.168.50.246:5678)
- **API Key Location**: `C:\Users\bermi\Projects\.env.shared`
- **Current API Key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyZjA1MzhkNS0zODJjLTRlYTMtYTMxZC1mNjkwZWY3ZWUzMGUiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzY4MDAxMDM4fQ.CsBAYnIYqulSVoJMAtvaNH7cDsfri38rs-hLRiNcoZI`

### Projects Using n8n
All projects should reference the shared env:
```bash
# Load shared environment
source C:\Users\bermi\Projects\.env.shared
# OR symlink: 
# New-Item -ItemType SymbolicLink -Path .env -Target C:\Users\bermi\Projects\.env.shared
```

## Current Session Resolution

### Claude Bridge Workflow
- **Status**: Created but not activated
- **ID**: `mNSllGYjERK3f5x1`
- **Location**: http://localhost:5678/workflow/mNSllGYjERK3f5x1
- **Action Required**: User must manually activate
- **Test Script**: `C:\Users\bermi\Projects\agent-agency-mcp\test-bridge.ps1`

### Next Steps
1. User activates workflow in n8n UI
2. Run test script to route design task to Claude
3. Claude generates WARP.md with execution steps
4. Execute steps to activate autonomous system

---

**Created**: 2026-01-09  
**Author**: Warp AI Agent  
**Purpose**: Document n8n workflow activation limitations and proper processes for future sessions
