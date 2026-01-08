# n8n Migration to Docker Guide

## Overview

Migrate all n8n workflows from QNAP (192.168.50.246:5678) to local Docker setup with:
- n8n on Docker
- PostgreSQL database
- Memory Service API
- All integrated in one Docker Compose stack

## Step 1: Export from QNAP n8n

### Option A: Automated Export (with API key)
```powershell
.\migrate-n8n.ps1 -QnapApiKey "your_api_key_here"
```

### Option B: Manual Export
1. Go to http://192.168.50.246:5678
2. Login to n8n
3. Go to Workflows page
4. Select all workflows (Ctrl+A)
5. Click **Download** button
6. Save as `n8n-export/workflows.json`

### Export Credentials
**Important**: n8n doesn't export secret values for security.

1. Go to Settings → Credentials
2. Document all credentials and their configuration
3. You'll need to re-enter secrets manually in Docker n8n

## Step 2: Configure Docker Environment

1. Copy environment template:
```powershell
cp .env.template .env
```

2. Edit `.env` and set:
```bash
# Generate random encryption key
POSTGRES_PASSWORD=your_secure_password
N8N_ENCRYPTION_KEY=$(openssl rand -hex 32)

# Optional: Add your API keys
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
```

## Step 3: Start Docker Stack

```powershell
cd C:\Users\bermi\Projects\ai-governance
docker-compose up -d
```

This starts:
- PostgreSQL (port 5432)
- n8n (port 5678)
- Memory Service (port 8765)

## Step 4: Set Up n8n

1. Go to http://localhost:5678
2. Create your owner account
3. Complete initial setup

## Step 5: Import Workflows

1. In n8n, click **Workflows** → **Import from File**
2. Select `n8n-export/workflows.json`
3. Review and confirm import

## Step 6: Reconfigure Credentials

For each workflow that uses credentials:

1. Go to Settings → Credentials
2. Recreate each credential type
3. Enter API keys/secrets
4. Update workflows to use new credentials

## Step 7: Update Connection Strings

Workflows connecting to services need updates:

### PostgreSQL
- **Old**: `192.168.50.246:5432`
- **New**: `postgres:5432` (Docker network)

### Memory Service
- **Old**: N/A
- **New**: `http://memory-service:8765` (Docker network)

### External Services
Keep existing URLs (e.g., Notion, OpenAI, etc.)

## Step 8: Test Workflows

1. Open each workflow
2. Click **Execute Workflow** (test button)
3. Verify it runs successfully
4. Check outputs are correct

## Step 9: Shut Down QNAP n8n

**Only after confirming everything works in Docker:**

1. SSH into QNAP or use Container Station
2. Stop n8n container
3. Optionally: backup QNAP n8n data

## Step 10: Update Global Rules

Update Warp rules to use new n8n URL:

```
Old: http://192.168.50.246:5678
New: http://localhost:5678
```

## Troubleshooting

### Can't connect to PostgreSQL
```powershell
docker-compose logs postgres
docker-compose restart postgres
```

### n8n won't start
```powershell
docker-compose logs n8n
# Check N8N_ENCRYPTION_KEY is set in .env
```

### Memory service not responding
```powershell
docker-compose logs memory-service
curl http://localhost:8765/
```

### Workflow fails with connection error
- Check if you updated connection strings
- Verify credentials are configured
- Check Docker network: `docker network inspect ai-governance_ai-network`

## Backup & Restore

### Backup
```powershell
# Backup PostgreSQL
docker-compose exec postgres pg_dump -U postgres agent_system > backup.sql

# Backup n8n data
docker cp n8n-docker:/home/node/.n8n ./n8n-backup

# Backup memory data
docker cp memory-service:/data ./memory-backup
```

### Restore
```powershell
# Restore PostgreSQL
cat backup.sql | docker-compose exec -T postgres psql -U postgres agent_system

# Restore n8n data
docker cp ./n8n-backup/. n8n-docker:/home/node/.n8n
```

## Useful Commands

```powershell
# View logs
docker-compose logs -f

# Restart specific service
docker-compose restart n8n

# Stop all services
docker-compose down

# Stop and remove volumes (fresh start)
docker-compose down -v

# Check service health
docker-compose ps
```

---

**Co-Authored-By: Warp <agent@warp.dev>**
