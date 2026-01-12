# INCIDENT RESPONSE PLAYBOOK

**Version:** 1.0  
**Last Updated:** 2026-01-12  
**Owner:** Engineering Team + Operations  
**Related:** ERROR_LOGGING_STANDARD.md, ERROR_HANDLING_PROTOCOL.md

---

## PURPOSE

Provide clear, actionable procedures for responding to production incidents to minimize impact and restore service quickly.

---

## INCIDENT SEVERITY LEVELS

### 🔴 SEV-1: CRITICAL
**Definition:** Complete service outage or critical functionality unavailable

**Examples:**
- Production site completely down
- Database unavailable
- Critical payment/auth systems offline
- Data breach or security compromise
- Major data loss

**Response:**
- **Page:** On-call engineer IMMEDIATELY
- **Escalate:** After 15 minutes if not resolved
- **Communication:** Status page update within 5 minutes
- **Target Resolution:** 1 hour

---

### 🟠 SEV-2: HIGH
**Definition:** Major degradation affecting multiple users

**Examples:**
- Key feature unavailable (checkout, login)
- Performance degradation >50%
- Intermittent errors affecting >10% users
- Failed deployment blocking releases
- External service failures affecting core features

**Response:**
- **Page:** On-call engineer during business hours
- **Escalate:** After 1 hour if not resolved
- **Communication:** Status page update within 15 minutes
- **Target Resolution:** 4 hours

---

### 🟡 SEV-3: MEDIUM
**Definition:** Minor degradation or non-critical feature impacted

**Examples:**
- Non-critical feature unavailable
- Performance degradation <50%
- Errors affecting <10% users
- Monitoring/alerting issues
- Slow response times (not timeout)

**Response:**
- **Notify:** On-call engineer via Slack/email
- **Escalate:** After 4 hours if not resolved
- **Communication:** Internal only (no status page)
- **Target Resolution:** 1 business day

---

### 🟢 SEV-4: LOW
**Definition:** Minimal user impact or cosmetic issues

**Examples:**
- UI glitches
- Non-critical typos
- Minor logging errors
- Low-priority bug reports
- Performance optimization opportunities

**Response:**
- **Create:** Bug ticket (no page)
- **Escalate:** Not applicable
- **Communication:** Internal only
- **Target Resolution:** Next sprint

---

## INCIDENT RESPONSE PHASES

```
DETECT → RESPOND → MITIGATE → RESOLVE → LEARN
```

---

## PHASE 1: DETECTION

### How Incidents Are Detected
1. **Automated Monitoring:** Alert triggers
2. **User Reports:** Support tickets, social media
3. **Manual Discovery:** Team member notices issue
4. **External Reports:** Third-party monitoring, partners

### Immediate Actions (First 60 Seconds)
```markdown
1. [ ] Acknowledge alert (stop paging)
2. [ ] Check monitoring dashboard
3. [ ] Verify incident is real (not false positive)
4. [ ] Determine severity (SEV-1 through SEV-4)
5. [ ] Open incident channel/war room
```

---

## PHASE 2: RESPONSE

### Incident Commander Responsibilities
**Role:** Coordinates response, makes decisions, manages communication

**First 5 Minutes:**
```markdown
1. [ ] Declare incident severity
2. [ ] Create incident channel (#incident-YYYYMMDD-NNN)
3. [ ] Post initial status update
4. [ ] Assign responders:
   - Primary engineer (investigation)
   - Secondary engineer (backup/research)
   - Communications lead (SEV-1/SEV-2 only)
5. [ ] Start incident timeline document
```

### Investigation Checklist
```markdown
1. [ ] What is the user-facing impact?
2. [ ] When did the incident start?
3. [ ] What changed recently? (deployments, config, traffic)
4. [ ] Check monitoring dashboards:
   - Error rates
   - Response times
   - Resource utilization (CPU, memory, disk)
   - Database performance
5. [ ] Review recent logs (ERROR/FATAL level)
6. [ ] Check external dependencies (APIs, CDN, cloud providers)
7. [ ] Verify no ongoing deployments or maintenance
```

### Information Gathering Commands
```bash
# Recent deployments
git log --oneline --since="2 hours ago"

# Error logs (last 10 minutes)
kubectl logs -l app=api --since=10m | grep ERROR

# Database connections
psql -c "SELECT count(*) FROM pg_stat_activity;"

# Redis status
redis-cli INFO stats

# System resources
top -b -n 1 | head -20
df -h

# Recent alerts
curl https://monitoring.example.com/api/alerts?since=1h
```

---

## PHASE 3: MITIGATION

### Mitigation Options (Fastest First)

#### 1️⃣ Immediate Actions (< 5 minutes)
```markdown
- [ ] Rollback last deployment
- [ ] Kill runaway process
- [ ] Restart crashed service
- [ ] Disable problematic feature flag
- [ ] Scale up resources (horizontal/vertical)
- [ ] Increase rate limits
- [ ] Clear cache
```

#### 2️⃣ Quick Fixes (5-30 minutes)
```markdown
- [ ] Apply hotfix to production
- [ ] Reroute traffic (failover to backup)
- [ ] Temporary config change
- [ ] Manual data correction
- [ ] Disable non-critical background jobs
```

#### 3️⃣ Longer-Term Fixes (30+ minutes)
```markdown
- [ ] Code fix + emergency deployment
- [ ] Database migration/repair
- [ ] Infrastructure reconfiguration
- [ ] Third-party service switch
```

### Decision Matrix: Fix vs Rollback
```
┌──────────────────────────────────────────────────┐
│ Can fix be deployed in < 15 minutes? ────→ FIX  │
│ Rollback available? ─────────────────────→ ROLL │
│ Rollback might cause more issues? ───────→ FIX  │
│ Unknown root cause? ─────────────────────→ ROLL │
└──────────────────────────────────────────────────┘

Default: ROLLBACK (safer option)
```

### Rollback Procedure
```bash
# 1. Identify last known good version
git log --oneline -10

# 2. Rollback deployment
kubectl rollout undo deployment/api-service

# 3. Verify rollback success
kubectl rollout status deployment/api-service

# 4. Check monitoring (error rate should drop)

# 5. Post status update
```

---

## PHASE 4: RESOLUTION

### Resolution Criteria
```markdown
- [ ] User-facing issue is resolved
- [ ] Error rates returned to baseline
- [ ] Performance metrics returned to normal
- [ ] Monitoring shows green status
- [ ] No immediate risk of recurrence
```

### Post-Resolution Checklist
```markdown
1. [ ] Update status page (RESOLVED)
2. [ ] Post resolution message in incident channel
3. [ ] Keep incident channel open for 30 min (watch for regression)
4. [ ] Update incident timeline with resolution time
5. [ ] Thank responders
6. [ ] Schedule post-mortem (within 48 hours for SEV-1/SEV-2)
```

---

## PHASE 5: LEARNING (POST-MORTEM)

### When Post-Mortem is Required
- **ALWAYS:** SEV-1 incidents
- **ALWAYS:** SEV-2 incidents
- **SOMETIMES:** SEV-3 if systemic issue
- **NEVER:** SEV-4 (bug fix is sufficient)

### Post-Mortem Timeline
```
Within 24h: Schedule meeting
Within 48h: Hold post-mortem meeting
Within 72h: Publish post-mortem document
Within 1 week: Complete action items
```

### Post-Mortem Template
```markdown
# Post-Mortem: [Incident Title]

**Date:** YYYY-MM-DD  
**Duration:** X hours Y minutes  
**Severity:** SEV-X  
**Responders:** @engineer1, @engineer2  
**Author:** @incident-commander

---

## EXECUTIVE SUMMARY
[2-3 sentence summary of what happened and impact]

---

## IMPACT
- **Users Affected:** X users (Y% of total)
- **Duration:** X hours Y minutes
- **Revenue Impact:** $X (if applicable)
- **SLA Breach:** Yes/No (target: 99.9%)
- **Data Loss:** Yes/No

---

## TIMELINE (All times in UTC)

| Time  | Event |
|-------|-------|
| 14:23 | Alert triggered: High error rate |
| 14:25 | Engineer acknowledged, began investigation |
| 14:32 | Root cause identified: Database connection pool exhausted |
| 14:35 | Mitigation started: Increased connection pool size |
| 14:40 | Service restored |
| 14:55 | Monitoring confirmed stable, incident closed |

---

## ROOT CAUSE
[Detailed explanation of what went wrong and why]

**What happened:**
- [Specific technical details]

**Why it happened:**
- [Underlying cause - code bug, config error, capacity issue, etc.]

**Why it wasn't caught earlier:**
- [Gap in monitoring, testing, etc.]

---

## DETECTION
**How was the incident detected?**
- [ ] Automated monitoring alert
- [ ] User report
- [ ] Manual discovery

**Time to detect:** X minutes (from incident start to detection)

**Could detection be faster?** Yes/No - [Explanation]

---

## RESPONSE
**Time to acknowledge:** X minutes  
**Time to engage:** X minutes  
**Time to mitigate:** X minutes  
**Total time to resolution:** X hours Y minutes

**What went well:**
- [Things that worked well during response]

**What could be improved:**
- [Things that slowed down response]

---

## RESOLUTION
**How was the incident resolved?**
- [Specific steps taken]

**Was this the correct resolution?** Yes/No  
**Permanent fix or temporary workaround?** [Explanation]

---

## ACTION ITEMS

### Prevent Recurrence (Must Do)
- [ ] **[@owner]** [Action item with clear owner and deadline]
- [ ] **[@owner]** [Action item]

### Improve Detection (Should Do)
- [ ] **[@owner]** [Action item]

### Improve Response (Nice to Have)
- [ ] **[@owner]** [Action item]

### Follow-Up Tasks
- [ ] **[@owner]** [Action item]

---

## LESSONS LEARNED

**What worked well:**
1. [Thing that helped during incident]
2. [Thing that helped]

**What didn't work:**
1. [Thing that hindered response]
2. [Thing that hindered]

**Lucky breaks:**
- [Things that could have made this worse but didn't]

---

## RELATED INCIDENTS
- [Link to similar past incidents, if any]

---

**Reviewed by:** @tech-lead, @engineering-manager  
**Published:** YYYY-MM-DD
```

### Post-Mortem Meeting Agenda
```markdown
1. Review timeline (10 min)
2. Discuss root cause (10 min)
3. Review detection and response (10 min)
4. Identify action items (20 min)
5. Assign owners and deadlines (10 min)

Total: 60 minutes
```

### Post-Mortem Culture Guidelines
- **Blameless:** Focus on systems, not individuals
- **Honest:** Full transparency on what went wrong
- **Actionable:** Every incident generates improvement actions
- **Learning-focused:** Treat incidents as learning opportunities

---

## COMMUNICATION

### Internal Communication (Incident Channel)

#### Status Update Template
```markdown
## [HH:MM] Update

**Status:** [Investigating | Mitigating | Resolved]
**Impact:** [Brief description]
**Current Actions:** [What we're doing now]
**Next Update:** [When to expect next update]
```

#### Update Frequency
```
SEV-1: Every 15 minutes
SEV-2: Every 30 minutes
SEV-3: Every 60 minutes
```

---

### External Communication (Status Page)

#### Initial Status (SEV-1/SEV-2 Only)
```markdown
🔴 [Service Name] - Investigating

We are investigating reports of [brief description of issue]. 
Users may experience [specific impact]. We will provide an 
update within 15 minutes.

Last updated: [timestamp]
```

#### Update Template
```markdown
🟠 [Service Name] - Identified

We have identified the issue as [brief description]. Our team 
is working on a fix. We expect to have this resolved within 
[time estimate].

Last updated: [timestamp]
```

#### Resolution Template
```markdown
🟢 [Service Name] - Resolved

The issue has been resolved. All services are operating normally. 
We apologize for any inconvenience.

Last updated: [timestamp]
```

---

### Communication Checklist
```markdown
**SEV-1:**
- [ ] Status page update within 5 minutes
- [ ] Customer email if affecting specific accounts
- [ ] Social media post (if public-facing)
- [ ] Notify key stakeholders (exec team)

**SEV-2:**
- [ ] Status page update within 15 minutes
- [ ] Internal stakeholder notification
- [ ] Customer email if prolonged (>1 hour)

**SEV-3:**
- [ ] Internal notification only
- [ ] No status page update

**SEV-4:**
- [ ] No notification required
```

---

## ON-CALL GUIDELINES

### On-Call Responsibilities
- Be available to respond within 15 minutes
- Have laptop with VPN access ready
- Be sober and able to respond
- Know how to access runbooks and monitoring
- Know escalation contacts

### On-Call Rotation
- **Duration:** 1 week per engineer
- **Handoff:** Monday 9am (local time)
- **Handoff Meeting:** 15 min sync on ongoing issues

### On-Call Compensation
- **Weekday (6pm-9am):** Time and a half
- **Weekend:** Double time
- **If paged:** Minimum 2 hours credited

---

## ESCALATION

### When to Escalate
```
SEV-1 not resolved in 15 minutes → Escalate
SEV-2 not resolved in 1 hour → Escalate
Need expertise not available → Escalate
Need authorization (e.g., AWS spend) → Escalate
Customer-facing decision needed → Escalate
```

### Escalation Paths
```
On-Call Engineer
    ↓
Engineering Manager
    ↓
VP Engineering
    ↓
CTO

[Parallel: Security incidents → Security Team]
[Parallel: Legal issues → Legal Team]
[Parallel: Customer issues → Customer Success]
```

---

## RUNBOOKS

### Critical Service Runbooks
Each critical service must have a runbook covering:

```markdown
# [Service Name] Runbook

## Service Overview
- **Purpose:** [What this service does]
- **Dependencies:** [What it depends on]
- **SLA:** [Uptime target]

## Common Issues

### Issue: [Problem description]
**Symptoms:** [How to identify]
**Cause:** [Why it happens]
**Fix:** [Step-by-step resolution]

## Monitoring Dashboards
- [Link to dashboard]

## Key Metrics
- Error rate: < 0.1%
- Response time: < 200ms p95
- Availability: > 99.9%

## Emergency Contacts
- On-call: [PagerDuty link]
- Owner: @engineer
- Backup: @engineer2

## Deployment
- How to deploy
- How to rollback

## Database Access
- Connection strings (read from secrets)
- Common queries

## Troubleshooting Commands
[Copy-paste ready commands]
```

---

## TOOLS & ACCESS

### Required Access for On-Call
```markdown
- [ ] AWS Console access (production)
- [ ] Kubernetes cluster access
- [ ] Database read access (production)
- [ ] Monitoring dashboard access (Datadog/Grafana)
- [ ] Log aggregation access (Splunk/ELK)
- [ ] Status page admin access
- [ ] PagerDuty admin access
- [ ] Incident channel permissions (Slack)
- [ ] VPN credentials
- [ ] SSH keys for production servers
```

### Monitoring Tools
- **Uptime:** Pingdom, StatusCake
- **Metrics:** Datadog, Grafana, CloudWatch
- **Logs:** Splunk, ELK, CloudWatch Logs
- **APM:** New Relic, Datadog APM
- **Errors:** Sentry, Rollbar

---

## INCIDENT METRICS

### Track These Metrics
```
Time to Detect (TTD): Incident start → Detection
Time to Acknowledge (TTA): Detection → Acknowledged
Time to Engage (TTE): Acknowledged → Responder engaged
Time to Mitigate (TTM): Engaged → User impact reduced
Time to Resolve (TTR): Engaged → Fully resolved

MTTR (Mean Time to Resolve): Average TTR across all incidents
Incident Count: Total incidents per month (by severity)
SLA Compliance: % of time meeting SLA targets
```

### Monthly Incident Report
```markdown
# Incident Report: [Month Year]

**Total Incidents:** X
- SEV-1: X
- SEV-2: X
- SEV-3: X

**MTTR:** X hours (target: <2 hours)
**SLA Compliance:** 99.X% (target: 99.9%)

**Top Incident Types:**
1. [Category] - X incidents
2. [Category] - X incidents

**Action Items Completed:** X/Y (Z% completion rate)

**Trends:**
- [Notable patterns or improvements]
```

---

## QUICK REFERENCE

### SEV-1 First 5 Minutes
```bash
1. kubectl get pods --all-namespaces | grep -v Running
2. kubectl top nodes
3. curl https://api.example.com/health
4. Open monitoring dashboard
5. Check #incidents Slack for related issues
6. Create incident channel: #incident-20260112-001
7. Post in incident channel: "SEV-1 declared: [description]"
8. Update status page
```

### Common Mitigation Commands
```bash
# Rollback deployment
kubectl rollout undo deployment/api-service

# Scale up replicas
kubectl scale deployment/api-service --replicas=10

# Restart pods
kubectl rollout restart deployment/api-service

# Disable feature flag
curl -X POST https://api.example.com/admin/feature-flags/new-feature/disable

# Clear Redis cache
redis-cli FLUSHALL

# Check recent logs
kubectl logs -l app=api --since=10m --tail=100
```

---

**Related Documents:**
- ERROR_LOGGING_STANDARD.md - Logging requirements
- ERROR_HANDLING_PROTOCOL.md - Error classification
- PEER_REVIEW_CHECKLIST.md - Code review to prevent incidents
- TESTING_PROTOCOLS.md - Testing to catch issues early

**Co-Authored-By: Warp <agent@warp.dev>**
