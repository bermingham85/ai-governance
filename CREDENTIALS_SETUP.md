# n8n Credentials Setup Guide

## Found Credentials in .env Files

The following credentials were found and need to be manually configured in n8n:

### 1. Notion API

**Source:** `bermech-n8n-workflows/.env`

```
Go to: Settings → Credentials → Add Credential → Notion API
Name: Notion API
API Key: [paste from NOTION_API_KEY in .env]
```

**Additional Info:**
- Agent Database ID: [from NOTION_AGENT_DB_ID]

### 2. PostgreSQL - Agent System

**Source:** `ai-governance/.env`

```
Go to: Settings → Credentials → Add Credential → Postgres
Name: PostgreSQL - Agent System
Host: postgres
Database: agent_system
User: postgres
Password: postgres_secure_2024
Port: 5432
SSL: Allow
```

### 3. OpenAI API (if needed)

```
Go to: Settings → Credentials → Add Credential → OpenAI API
Name: OpenAI
API Key: [your OpenAI key]
```

### 4. Anthropic/Claude API (if needed)

```
Go to: Settings → Credentials → Add Credential → Anthropic
Name: Claude/Anthropic
API Key: [your Anthropic key]
```

## Quick Setup Steps

1. Open n8n: http://localhost:5678
2. Go to **Settings** → **Credentials**
3. For each credential above:
   - Click **Add Credential**
   - Select the credential type
   - Fill in the details
   - Click **Save**

## Workflow Updates Needed

After creating credentials, update these workflows to use them:

- Agent Agency workflows → Use PostgreSQL credential
- Notion integration workflows → Use Notion API credential
- AI-powered workflows → Use OpenAI/Claude credentials

## Testing Credentials

To test if a credential works:
1. Open any workflow that uses it
2. Click on the node using the credential
3. Click **Test step** or **Execute node**
4. Check for errors

---

**Co-Authored-By: Warp <agent@warp.dev>**
