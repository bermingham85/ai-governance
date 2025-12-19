# SECRETS REGISTRY

**Version:** 1.0.0  
**Last Scanned:** 2025-12-19 20:15:41  
**Purpose:** Centralized reference for all secrets across projects  
**⚠️  CRITICAL:** This file contains NO secret values, only metadata

---

## Centralized Secrets Location

**Primary Storage:** Each project's .env file  
**Backup/Reference:** n8n credentials vault (http://192.168.50.246:5678)

### Shared Secrets (Used by Multiple Projects)

These secrets should be consistent across projects:

| Secret Name | Used By | Purpose | Storage Location |
|-------------|---------|---------|------------------|
| N8N_URL | Multiple | n8n instance URL | Project .env files |
| N8N_API_KEY | agent-agency-mcp | n8n API access | agent-agency-mcp/.env |
| ANTHROPIC_API_KEY | n8n workflows | Claude API access | n8n credentials vault |
| NOTION_API_KEY | Multiple | Notion integration | Project .env files |

---

## Project-Specific Secrets

### agent-agency-mcp

**File:** `agent-agency-mcp\.env`  
**Secrets Count:** 9  
**Last Modified:** 2025-12-18

**Keys Found:**
- `DB_HOST`
- `DB_PORT`
- `DB_NAME`
- `DB_USER`
- `DB_PASSWORD`
- `NOTION_API_KEY`
- `NOTION_AGENT_DB_ID`
- `LOG_LEVEL`
- `AGENT_TIMEOUT`

### agent-agency-mcp

**File:** `agent-agency-mcp\.env.example`  
**Secrets Count:** 9  
**Last Modified:** 2025-12-03

**Keys Found:**
- `DB_HOST`
- `DB_PORT`
- `DB_NAME`
- `DB_USER`
- `DB_PASSWORD`
- `NOTION_API_KEY`
- `NOTION_AGENT_DB_ID`
- `LOG_LEVEL`
- `AGENT_TIMEOUT`

### ai-orchestrator

**File:** `ai-orchestrator\extracted\accounting_automation_project\.env`  
**Secrets Count:** 1  
**Last Modified:** 2025-09-22

**Keys Found:**
- `MCP_URL`

### ai-orchestrator

**File:** `ai-orchestrator\extracted\LLMBridgework\LLMBridgework\.env.example`  
**Secrets Count:** 5  
**Last Modified:** 2025-09-17

**Keys Found:**
- `PORT`
- `OLLAMA_BASE_URL`
- `LMSTUDIO_BASE_URL`
- `ALLOWED_URLS`
- `ALLOWED_EXECUTABLES`

### ai-orchestrator

**File:** `ai-orchestrator\extracted\LLMBridgework (1)\LLMBridgework\.env.example`  
**Secrets Count:** 6  
**Last Modified:** 2025-09-20

**Keys Found:**
- `PORT`
- `OLLAMA_BASE_URL`
- `LMSTUDIO_BASE_URL`
- `ALLOWED_URLS`
- `ALLOWED_EXECUTABLES`
- `AFFOGATO_API_KEY`

### ai-orchestrator

**File:** `ai-orchestrator\extracted\LLMBridgework (2)\LLMBridgework\.env`  
**Secrets Count:** 25  
**Last Modified:** 2025-09-27

**Keys Found:**
- `OPENAI_API_KEY`
- `AFFOGATO_API_KEY`
- `ELEVENLABS_API_KEY`
- `DATABASE_URL`
- `CHARACTERS_MASTER_DB`
- `GREMLOS_CONTENT_VOLUME`
- `GREMLOS_DEFAULT_PLATFORMS`
- `GREMLOS_CHARACTER_ARCHETYPES`
- `TRENDS_SOURCE`
- `ENABLE_TWITTER_TRENDS`
- `ENABLE_TIKTOK_TRENDS`
- `MCP_PORT`
- `MCP_HOST`
- `PORT`
- `DASHBOARD_PORT`
- `DASHBOARD_HOST`
- `OLLAMA_BASE_URL`
- `LMSTUDIO_BASE_URL`
- `ALLOWED_URLS`
- `ALLOWED_EXECUTABLES`
- `NODE_ENV`
- `REPL_ID`
- `REPL_SLUG`
- `REPL_OWNER`
- `SESSION_SECRET`

### ai-orchestrator

**File:** `ai-orchestrator\extracted\LLMBridgework (2)\LLMBridgework\.env.example`  
**Secrets Count:** 23  
**Last Modified:** 2025-09-27

**Keys Found:**
- `OPENAI_API_KEY`
- `AFFOGATO_API_KEY`
- `ELEVENLABS_API_KEY`
- `DATABASE_URL`
- `CHARACTERS_MASTER_DB`
- `IMAGE_ASSETS_DB`
- `GREMLOS_CONTENT_VOLUME`
- `GREMLOS_DEFAULT_PLATFORMS`
- `GREMLOS_CHARACTER_ARCHETYPES`
- `TRENDS_SOURCE`
- `ENABLE_TWITTER_TRENDS`
- `ENABLE_TIKTOK_TRENDS`
- `PORT`
- `OLLAMA_BASE_URL`
- `LMSTUDIO_BASE_URL`
- `ALLOWED_URLS`
- `ALLOWED_EXECUTABLES`
- `MCP_PORT`
- `MCP_HOST`
- `DASHBOARD_PORT`
- `DASHBOARD_HOST`
- `NODE_ENV`
- `SESSION_SECRET`

### ai-orchestrator

**File:** `ai-orchestrator\extracted\LLMBridgework (3)\LLMBridgework\.env`  
**Secrets Count:** 26  
**Last Modified:** 2025-10-03

**Keys Found:**
- `OPENAI_API_KEY`
- `AFFOGATO_API_KEY`
- `ELEVENLABS_API_KEY`
- `DATABASE_URL`
- `CHARACTERS_MASTER_DB`
- `GREMLOS_CONTENT_VOLUME`
- `GREMLOS_DEFAULT_PLATFORMS`
- `GREMLOS_CHARACTER_ARCHETYPES`
- `TRENDS_SOURCE`
- `ENABLE_TWITTER_TRENDS`
- `ENABLE_TIKTOK_TRENDS`
- `MCP_PORT`
- `MCP_HOST`
- `PORT`
- `DASHBOARD_PORT`
- `DASHBOARD_HOST`
- `OLLAMA_BASE_URL`
- `LMSTUDIO_BASE_URL`
- `ALLOWED_URLS`
- `ALLOWED_EXECUTABLES`
- `NODE_ENV`
- `REPL_ID`
- `REPL_SLUG`
- `REPL_OWNER`
- `SESSION_SECRET`
- `PORT`

### ai-orchestrator

**File:** `ai-orchestrator\extracted\LLMBridgework (3)\LLMBridgework\.env.example`  
**Secrets Count:** 32  
**Last Modified:** 2025-10-21

**Keys Found:**
- `PORT`
- `NODE_ENV`
- `DATABASE_URL`
- `ANTHROPIC_API_KEY`
- `OPENAI_API_KEY`
- `AFFOGATO_API_KEY`
- `ELEVENLABS_API_KEY`
- `MCP_GATEWAY_KEY`
- `OLLAMA_BASE_URL`
- `LMSTUDIO_BASE_URL`
- `NOTION_TOKEN`
- `NOTION_STORYLINE_DB`
- `NOTION_CHARACTER_DB`
- `SLACK_BOT_TOKEN`
- `GOOGLE_APPLICATION_CREDENTIALS`
- `GITHUB_TOKEN`
- `FIGMA_TOKEN`
- `CANVA_API_KEY`
- `LINEAR_API_KEY`
- `ASANA_TOKEN`
- `ZAPIER_API_KEY`
- `ZAPIER_WEBHOOK_URL`
- `ALLOWED_URLS`
- `ALLOWED_EXECUTABLES`
- `VITE_API_URL`
- `VITE_WS_URL`
- `GREMLOS_CONTENT_VOLUME`
- `GREMLOS_DEFAULT_PLATFORMS`
- `GREMLOS_CHARACTER_ARCHETYPES`
- `TRENDS_SOURCE`
- `ENABLE_TWITTER_TRENDS`
- `ENABLE_TIKTOK_TRENDS`

### ai-orchestrator

**File:** `ai-orchestrator\extracted\LLMBridgework (3)\LLMBridgework\.env.local`  
**Secrets Count:** 1  
**Last Modified:** 2025-10-06

**Keys Found:**
- `PORT`

### brand-launchpad-service

**File:** `brand-launchpad-service\.env.example`  
**Secrets Count:** 8  
**Last Modified:** 2025-10-28

**Keys Found:**
- `OPENAI_API_KEY`
- `WEBHOOK_BRAND_ANALYSIS`
- `WEBHOOK_CONTENT_GENERATION`
- `WEBHOOK_METRICS_UPDATE`
- `FRONTEND_PORT`
- `BRAND_ASSETS_PATH`
- `NODE_ENV`
- `DEBUG`

### chatgpt-mcp-server

**File:** `chatgpt-mcp-server\.env.example`  
**Secrets Count:** 1  
**Last Modified:** 2025-10-31

**Keys Found:**
- `PORT`

### gremlos-world-puppet

**File:** `gremlos-world-puppet\.env`  
**Secrets Count:** 26  
**Last Modified:** 2025-10-23

**Keys Found:**
- `OPENAI_API_KEY`
- `AFFOGATO_API_KEY`
- `ELEVENLABS_API_KEY`
- `DATABASE_URL`
- `CHARACTERS_MASTER_DB`
- `GREMLOS_CONTENT_VOLUME`
- `GREMLOS_DEFAULT_PLATFORMS`
- `GREMLOS_CHARACTER_ARCHETYPES`
- `TRENDS_SOURCE`
- `ENABLE_TWITTER_TRENDS`
- `ENABLE_TIKTOK_TRENDS`
- `MCP_PORT`
- `MCP_HOST`
- `PORT`
- `DASHBOARD_PORT`
- `DASHBOARD_HOST`
- `OLLAMA_BASE_URL`
- `LMSTUDIO_BASE_URL`
- `ALLOWED_URLS`
- `ALLOWED_EXECUTABLES`
- `NODE_ENV`
- `REPL_ID`
- `REPL_SLUG`
- `REPL_OWNER`
- `SESSION_SECRET`
- `PORT`

### gremlos-world-puppet

**File:** `gremlos-world-puppet\.env.example`  
**Secrets Count:** 32  
**Last Modified:** 2025-10-23

**Keys Found:**
- `PORT`
- `NODE_ENV`
- `DATABASE_URL`
- `ANTHROPIC_API_KEY`
- `OPENAI_API_KEY`
- `AFFOGATO_API_KEY`
- `ELEVENLABS_API_KEY`
- `MCP_GATEWAY_KEY`
- `OLLAMA_BASE_URL`
- `LMSTUDIO_BASE_URL`
- `NOTION_TOKEN`
- `NOTION_STORYLINE_DB`
- `NOTION_CHARACTER_DB`
- `SLACK_BOT_TOKEN`
- `GOOGLE_APPLICATION_CREDENTIALS`
- `GITHUB_TOKEN`
- `FIGMA_TOKEN`
- `CANVA_API_KEY`
- `LINEAR_API_KEY`
- `ASANA_TOKEN`
- `ZAPIER_API_KEY`
- `ZAPIER_WEBHOOK_URL`
- `ALLOWED_URLS`
- `ALLOWED_EXECUTABLES`
- `VITE_API_URL`
- `VITE_WS_URL`
- `GREMLOS_CONTENT_VOLUME`
- `GREMLOS_DEFAULT_PLATFORMS`
- `GREMLOS_CHARACTER_ARCHETYPES`
- `TRENDS_SOURCE`
- `ENABLE_TWITTER_TRENDS`
- `ENABLE_TIKTOK_TRENDS`

### gremlos-world-puppet

**File:** `gremlos-world-puppet\.env.local`  
**Secrets Count:** 1  
**Last Modified:** 2025-10-23

**Keys Found:**
- `PORT`

### gremlos-world-puppet

**File:** `gremlos-world-puppet\frontend\.env`  
**Secrets Count:** 2  
**Last Modified:** 2025-10-06

**Keys Found:**
- `VITE_SUPABASE_ANON_KEY`
- `VITE_SUPABASE_URL`

### gremlos-world-puppet

**File:** `gremlos-world-puppet\frontend\.env.example`  
**Secrets Count:** 2  
**Last Modified:** 2025-10-06

**Keys Found:**
- `VITE_API_URL`
- `VITE_WS_URL`

### lm-cleaning-booking

**File:** `lm-cleaning-booking\.env`  
**Secrets Count:** 2  
**Last Modified:** 2025-11-23

**Keys Found:**
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`

### lm-cleaning-booking

**File:** `lm-cleaning-booking\.env.example`  
**Secrets Count:** 2  
**Last Modified:** 2025-11-23

**Keys Found:**
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`

### midjourney-news-automation

**File:** `midjourney-news-automation\.env`  
**Secrets Count:** 22  
**Last Modified:** 2025-10-30

**Keys Found:**
- `OPENAI_API_KEY`
- `DISCORD_TOKEN`
- `DISCORD_CHANNEL_ID`
- `DISCORD_USER_ID`
- `DISCORD_SERVER_ID`
- `MIDJOURNEY_API_KEY`
- `MIDJOURNEY_API_URL`
- `GOOGLE_CLIENT_ID`
- `GOOGLE_CLIENT_SECRET`
- `GOOGLE_REDIRECT_URI`
- `GOOGLE_REFRESH_TOKEN`
- `GOOGLE_DOC_ID`
- `RSS_FEED_URL`
- `RSS_FETCH_INTERVAL`
- `WEBHOOK_PORT`
- `WEBHOOK_URL`
- `DEFAULT_IMAGE_STYLE`
- `DEFAULT_ASPECT_RATIO`
- `AUTO_UPSCALE`
- `UPSCALE_INDEX`
- `LOG_LEVEL`
- `LOG_FILE`

### midjourney-news-automation

**File:** `midjourney-news-automation\.env.example`  
**Secrets Count:** 23  
**Last Modified:** 2025-10-28

**Keys Found:**
- `ANTHROPIC_API_KEY`
- `OPENAI_API_KEY`
- `DISCORD_TOKEN`
- `DISCORD_CHANNEL_ID`
- `DISCORD_USER_ID`
- `DISCORD_SERVER_ID`
- `MIDJOURNEY_API_KEY`
- `MIDJOURNEY_API_URL`
- `GOOGLE_CLIENT_ID`
- `GOOGLE_CLIENT_SECRET`
- `GOOGLE_REDIRECT_URI`
- `GOOGLE_REFRESH_TOKEN`
- `GOOGLE_DOC_ID`
- `RSS_FEED_URL`
- `RSS_FETCH_INTERVAL`
- `WEBHOOK_PORT`
- `WEBHOOK_URL`
- `DEFAULT_IMAGE_STYLE`
- `DEFAULT_ASPECT_RATIO`
- `AUTO_UPSCALE`
- `UPSCALE_INDEX`
- `LOG_LEVEL`
- `LOG_FILE`

### openai-notion-mcp

**File:** `openai-notion-mcp\.env.template`  
**Secrets Count:** 4  
**Last Modified:** 2025-12-02

**Keys Found:**
- `OPENAI_API_KEY`
- `ANTHROPIC_API_KEY`
- `NOTION_API_KEY`
- `OPENAI_MODEL`

---

## Security Guidelines

### DO:
- ✅ Keep .env files in .gitignore
- ✅ Use n8n credentials vault for workflow secrets
- ✅ Rotate secrets regularly (see SECRET_ROTATION_LOG.md)
- ✅ Use environment-specific .env files (.env.production, .env.dev)

### DON'T:
- ❌ Commit .env files to Git
- ❌ Share .env files via chat/email
- ❌ Hard-code secrets in scripts
- ❌ Use production secrets in development

---

## Centralized Access Pattern

### For Projects Needing Shared Secrets

Instead of duplicating secrets across projects, reference from centralized location:

**Option 1: Symlink (Recommended)**
```powershell
# Create symlink to shared secrets
New-Item -ItemType SymbolicLink -Path "project\.env" -Target "C:\Users\bermi\Projects\.env.shared"
```

**Option 2: Script-based Loading**
```powershell
# Load from centralized location
$SharedEnv = Get-Content "C:\Users\bermi\Projects\.env.shared"
foreach ($line in $SharedEnv) {
    if ($line -match "^([A-Z_]+)=(.+)$") {
        [Environment]::SetEnvironmentVariable($Matches[1], $Matches[2])
    }
}
```

**Option 3: n8n Credentials Vault**
- Store in n8n: Settings → Credentials
- Reference in workflows
- Most secure for automation

---

## Secret Rotation Checklist

When rotating a secret:

1. Update in primary location (.env or n8n vault)
2. Update in all dependent projects
3. Log rotation in SECRET_ROTATION_LOG.md
4. Verify all services still work
5. Revoke old secret

---

## Discovered Secrets Summary

**Total .env files found:** 23  
**Projects with secrets:** 8

---

**Generated:** 2025-12-19T20:15:41.4493713+00:00  
**Tool:** scripts/scan_secrets.ps1  
**Source of Truth:** ai-governance repository

---

**Co-Authored-By: Warp <agent@warp.dev>**
