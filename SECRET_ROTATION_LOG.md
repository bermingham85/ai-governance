# Secret Rotation Log

**Purpose:** Track secret rotations (metadata only, NO VALUES)  
**Governance:** Referenced by SECRETS_POLICY.md  
**Last Updated:** 2025-12-18

---

## Rotation Schedule

| Secret Name | Last Rotated | Reason | Next Rotation Due | Rotated By |
|-------------|--------------|--------|-------------------|------------|
| ANTHROPIC_API_KEY | 2025-12-18 | Initial setup | 2026-03-18 (90 days) | User |
| OPENAI_API_KEY | 2025-12-18 | Initial setup | 2026-03-18 (90 days) | User |
| ELEVENLABS_API_KEY | - | (Needs initial inventory) | TBD | - |
| SERPAPI_API_KEY | - | (Needs initial inventory) | TBD | - |
| NOTION_API_KEY | - | (Needs initial inventory) | TBD | - |
| N8N_API_KEY | - | (Needs initial inventory) | TBD | - |
| GOOGLE_SERVICE_ACCOUNT | - | (Needs initial inventory) | TBD | - |
| GOOGLE_CLIENT_ID | - | (Needs initial inventory) | TBD | - |

---

## Rotation Notes

### 2025-12-18: Initial Setup

**Actions Taken:**
- Established governance framework with SECRETS_POLICY.md
- Created this rotation log
- Documented existing secret storage locations:
  - C:\Users\bermi\.env (working keys)
  - C:\tools\.env (N8N and shared API keys)
  - n8n credentials vault (http://192.168.50.246:5678)
  - Project-specific .env files

**Next Actions Required:**
- Complete inventory of all secrets in each location
- Establish baseline rotation dates for existing secrets
- Set up calendar reminders for scheduled rotations
- Create .env.example files for each location

**Rotation Policies Established:**
- High-security keys (AI services): 90-day rotation
- Medium-security keys (search, utilities): 180-day rotation
- Low-security keys (public APIs): 365-day rotation
- Emergency rotation: Immediate upon compromise

---

## Incident Log

### No incidents recorded

*Format for incidents:*
```
### YYYY-MM-DD: Incident Title

**Secret Affected:** SECRET_NAME  
**Incident Type:** Accidental commit / Exposure / Suspected compromise  
**Response Time:** X hours  
**Actions Taken:**
- Rotated key immediately
- Updated all locations
- Revoked old key
- Verified no unauthorized usage

**Root Cause:** [Brief description]  
**Preventive Measures:** [What was changed to prevent recurrence]
```

---

## Audit History

### 2025-12-18: Initial Audit

**Auditor:** Warp (Governance Bootstrapper)  
**Scope:** Establish baseline documentation  

**Findings:**
- Secret storage locations documented
- .gitignore patterns in place
- No secrets found in Git history
- Rotation schedule defined

**Compliance Status:** ✅ Compliant with SECRETS_POLICY.md v1.0.0

**Next Audit Due:** 2025-03-18 (Quarterly)

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2025-12-18 | Initial rotation log | Warp (execution) |

---

**Document Owner:** ai-governance repository  
**Referenced By:** SECRETS_POLICY.md

---

**Co-Authored-By: Warp <agent@warp.dev>**
