# AI Governance Framework

**Version:** 1.0.0  
**Last Updated:** 2025-12-18  
**Status:** Foundation Active

---

## Purpose

This repository contains the authoritative governance documents for AI system operations. It defines strict role separation, handover protocols, capabilities, and secret handling policies.

**Key Principle:** GitHub is the source of truth. All governance changes must be committed here.

---

## Core Documents

### GLOBAL_AI_RULES.md
Defines RULE 12-15 (Strict Role Separation):
- RULE 12: Strict role separation between design and execution
- RULE 13: Mandatory handover protocol
- RULE 14: No self-initiated execution
- RULE 15: Automatic task routing

### HANDOVER_PROTOCOL.md
Standard format for all handovers between Claude (design) and Warp (execution).

### CAPABILITIES_MANIFEST.md
Authoritative reference for what each system can and cannot do:
- Claude: Design, review, audit (never executes)
- Warp: Execute, file ops, Git ops (never designs)
- GitHub: Source of truth storage

### SECRETS_POLICY.md
Where secrets live and how to handle them (NO VALUES):
- Storage locations
- Naming conventions
- Handling rules
- Rotation procedures

### SECRET_ROTATION_LOG.md
Tracking log for secret rotations (metadata only, no values).

---

## Prompt Templates

Located in `prompts/` directory:

- **handover_claude_to_warp.md** — Claude → Warp execution handover
- **task_router.md** — Task classification and routing logic
- **handover_warp_to_claude_review.md** — Warp → Claude review handover

---

## How to Use This Repository

### For Claude (Design AI)
1. Reference these documents when designing solutions
2. Create WARP.md handover documents following HANDOVER_PROTOCOL.md
3. Never execute or modify files directly
4. Hand off all execution to Warp

### For Warp (Execution AI)
1. Pull latest governance documents before each major task
2. Validate handover instructions against CAPABILITIES_MANIFEST.md
3. Execute step-by-step as specified
4. Report completion back to Claude/user
5. Commit any governance updates to this repository

### For Users
1. This repository defines how AI systems must operate
2. Modifications require explicit approval
3. All changes must be committed via Warp (not manually edited)
4. Protected zones defined in CAPABILITIES_MANIFEST.md must be respected

---

## Integration with Warp Rules

This repository provides **Global Rules** for Warp's governance system:

**Rules Precedence:**
1. Project subdirectory WARP.md (highest)
2. Project root WARP.md
3. Global Rules (this repository)

**To add this as a Global Rule in Warp:**
1. Open Warp Drive: Personal > Rules > Global
2. Add rule: "Follow strict role separation from ai-governance repository"
3. Reference: `C:\Users\bermi\Projects\ai-governance\GLOBAL_AI_RULES.md`

---

## Repository Structure

```
ai-governance/
├── README.md                              # This file
├── PHASES_STATUS.md                       # Implementation progress tracker
├── REQUIRED_GOVERNANCE_GUIDES.md          # Complete roadmap
├── GLOBAL_AI_RULES.md                     # RULE 12-15 core rules
├── ERROR_HANDLING_PROTOCOL.md             # Error classification
├── guides/
│   ├── PROJECT_DECISION_MATRIX.md         # New vs extend framework
│   ├── HANDOVER_PROTOCOL.md               # AI handover procedures
│   └── PLATFORM_DELEGATION_MATRIX.md      # Task routing + emergent handling
├── standards/
│   ├── DEFINITION_OF_DONE.md              # Task completion criteria
│   ├── CODE_QUALITY_STANDARDS.md          # Quality metrics
│   ├── TESTING_PROTOCOLS.md               # Testing requirements
│   ├── PEER_REVIEW_CHECKLIST.md           # Code review standards
│   ├── ERROR_LOGGING_STANDARD.md          # Logging requirements
│   └── INCIDENT_RESPONSE_PLAYBOOK.md      # Production incidents
├── scripts/
│   ├── pre-flight-check.ps1               # Pre-commit validation
│   └── profile-snippet.ps1                # PowerShell integration
├── adr/                                    # Architecture Decision Records
└── prompts/                                # Legacy prompt templates
```

---

## Protected Zones

The following areas must NEVER be accessed by any AI system:
- Photos (all locations)
- Personal files (documents, writing, notes)
- Fillmore / Filmora project files

**Scope:** All operations limited to `C:\Users\bermi\Projects\` unless explicitly authorized.

---

## n8n Integration

**ONLY n8n Instance:** http://192.168.50.246:5678

All scripts and workflows MUST use this instance. No other n8n instances are authorized.

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2025-12-18 | Initial governance framework | Claude (designed) / Warp (executed) |

---

## Next Review

**Date:** 2025-01-18  
**Focus:** Capability verification, rule compliance audit

---

## Contact & Support

This is the authoritative governance repository for the AI system ecosystem under `C:\Users\bermi\Projects\`.

For questions or governance changes:
1. Propose changes via Claude (design phase)
2. Execute changes via Warp (with approval)
3. Commit to this repository (source of truth)

**Co-Authored-By: Warp <agent@warp.dev>**
