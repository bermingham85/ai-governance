# n8n Automation Workflows

**Version:** 1.0.0  
**Purpose:** Automated monitoring, maintenance, and continuous improvement  
**n8n Instance:** http://192.168.50.246:5678

---

## Overview

These workflows implement the automation layer for autonomous system operations:
- **Health monitoring** - Detect issues before they become problems
- **Dependency management** - Automatic security patches
- **Error analysis** - Pattern detection and continuous improvement

---

## Workflows

### 1. Health Check Monitor
**File:** `health-check-monitor.json`  
**Schedule:** Every 6 hours  
**Purpose:** Monitor project health across all active projects

**What it does:**
1. Gets list of active projects from governance
2. Calls Warp to run health checks (tests, linting, Docker, dependencies)
3. Aggregates results
4. Creates GitHub issues for any failures
5. Logs healthy status when all pass

**Health checks performed:**
- ✅ All tests passing
- ✅ No linting errors
- ✅ Docker builds successfully
- ✅ Dependencies up to date
- ✅ No security vulnerabilities

**Setup required:**
- `/webhook/warp-health-check` endpoint
- `/webhook/create-github-issue` endpoint
- Update project list in "Get Active Projects" node

---

### 2. Automated Dependency Updater
**File:** `dependency-updater.json`  
**Schedule:** Weekly (Sunday 2 AM)  
**Purpose:** Keep dependencies current and secure

**What it does:**
1. Scans Python projects for outdated packages
2. Runs security audit (`pip-audit`)
3. Classifies updates (security/minor/major)
4. **Auto-applies security patches** with testing
5. Creates GitHub issues for minor/major updates

**Update policy:**
- **Security patches:** Applied immediately (with tests)
- **Minor updates:** Issue created for review
- **Major updates:** Issue created with breaking-change label

**Setup required:**
- `/webhook/warp-execute` endpoint
- Update Python projects list in "Get Python Projects" node
- Configure GitHub credentials

---

### 3. Error Log Aggregator
**File:** `error-log-aggregator.json`  
**Schedule:** Daily (11 PM)  
**Purpose:** Detect recurring error patterns for continuous improvement

**What it does:**
1. Finds all ERROR_LOG.md files across projects
2. Reads recent error entries
3. Detects recurring patterns (3+ occurrences)
4. Sends patterns to Claude for analysis
5. Proposes template/rule improvements

**Pattern detection:**
- Same error appearing in multiple projects
- Errors occurring 3+ times
- Common root causes
- Architecture issues

**Setup required:**
- `/webhook/warp-execute` endpoint
- `/webhook/claude-review` endpoint
- `/webhook/governance-log` endpoint

---

## Installation

### Import Workflows

1. Open n8n: http://192.168.50.246:5678
2. Go to **Workflows** → **Import from File**
3. Import each JSON file:
   - `health-check-monitor.json`
   - `dependency-updater.json`
   - `error-log-aggregator.json`
4. Activate each workflow

### Required Webhooks

Create these webhook endpoints in n8n:

#### 1. Warp Health Check (`/webhook/warp-health-check`)
**Purpose:** Execute health checks via Warp

**Input:**
```json
{
  "project_path": "C:\\Users\\bermi\\Projects\\project-name",
  "project_name": "project-name",
  "checks": "tests,linting,docker,dependencies"
}
```

**Output:**
```json
{
  "status": "healthy" | "failed",
  "project_name": "project-name",
  "failures": ["test failed", "linting errors"],
  "severity": "low" | "medium" | "high"
}
```

**Implementation:**
```javascript
// Webhook node → HTTP Request to Warp MCP
// Execute: cd project_path && run checks
// Parse results and return status
```

#### 2. Warp Execute (`/webhook/warp-execute`)
**Purpose:** Execute arbitrary commands via Warp

**Input:**
```json
{
  "project_path": "C:\\Users\\bermi\\Projects\\project-name",
  "commands": ["command1", "command2"],
  "test_after": true,
  "commit_if_success": true,
  "commit_message": "commit message"
}
```

**Output:**
```json
{
  "success": true,
  "result": "command output",
  "tests_passed": true,
  "commit_hash": "abc123"
}
```

#### 3. Create GitHub Issue (`/webhook/create-github-issue`)
**Purpose:** Create GitHub issues for failures/updates

**Input:**
```json
{
  "title": "Issue title",
  "body": "Issue description",
  "labels": "label1,label2,label3"
}
```

**Output:**
```json
{
  "issue_url": "https://github.com/user/repo/issues/123",
  "issue_number": 123
}
```

**Implementation:**
```javascript
// Use GitHub node or HTTP Request node
// POST to /repos/{owner}/{repo}/issues
// With proper authentication
```

#### 4. Claude Review (`/webhook/claude-review`)
**Purpose:** Request Claude analysis

**Input:**
```json
{
  "task": "error_pattern_analysis",
  "data": {...},
  "request": "Analysis request description"
}
```

**Output:**
```json
{
  "analysis": "Claude's analysis",
  "recommendations": [...],
  "action_items": [...]
}
```

---

## Configuration

### Update Project Lists

Each workflow has a "Get [Type] Projects" node. Update these with your active projects:

**Health Check Monitor:**
```javascript
const projects = [
  'animation-agent',
  'chatgpt-mcp-server',
  'hourly-autopilot-system',
  'n8n-mcp',
  // Add your projects here
];
```

**Dependency Updater:**
```javascript
const pythonProjects = [
  {
    name: 'project-name',
    path: 'C:\\Users\\bermi\\Projects\\project-name',
    type: 'python'
  },
  // Add more projects
];
```

### Adjust Schedules

Modify schedule nodes to fit your needs:

**Health Check Monitor:**
- Default: Every 6 hours
- Recommended: 4-8 hours
- Too frequent: < 2 hours (wastes resources)

**Dependency Updater:**
- Default: Weekly (Sunday 2 AM)
- Recommended: Weekly
- Security patches: Consider daily

**Error Log Aggregator:**
- Default: Daily (11 PM)
- Recommended: Daily
- Analysis intensive: Consider 2-3 days

---

## Monitoring

### Execution History

View workflow executions:
1. Open workflow in n8n
2. Click **Executions** tab
3. Review success/failure rates

### Debug Failed Executions

1. Click failed execution
2. Review node outputs
3. Check error messages
4. Fix webhook endpoints or data format

### Notifications

Add notification nodes to workflows:
- **Email** - For critical failures
- **Slack** - For team notifications
- **Discord** - For automated updates

---

## Best Practices

### 1. Test Before Activating

1. Import workflow
2. Click **Execute Workflow** (manual trigger)
3. Review outputs
4. Fix any errors
5. Activate when working

### 2. Monitor Resource Usage

- Check n8n system resources
- Adjust schedules if heavy load
- Consider splitting large workflows

### 3. Review and Iterate

- Weekly: Review execution success rates
- Monthly: Adjust schedules based on patterns
- Quarterly: Add new projects to lists

### 4. Backup Workflows

```bash
# Export all workflows monthly
# Store in ai-governance/n8n-workflows/backups/
```

---

## Troubleshooting

### Workflow Not Triggering

**Problem:** Schedule not firing  
**Solution:**
1. Check n8n is running
2. Verify schedule node configuration
3. Check n8n logs

### Webhook Returns 404

**Problem:** Endpoint not found  
**Solution:**
1. Verify webhook is created in n8n
2. Check URL matches workflow call
3. Ensure webhook is activated

### Commands Fail

**Problem:** Warp execution fails  
**Solution:**
1. Verify project paths are correct
2. Check PowerShell syntax
3. Test commands manually first
4. Review ERROR_LOG.md

### GitHub Issue Creation Fails

**Problem:** Authentication or permissions  
**Solution:**
1. Check GitHub credentials in n8n
2. Verify token has `repo` scope
3. Test with GitHub API directly

---

## Extending Workflows

### Add New Project Type

For Node.js projects, create similar workflow:

1. Copy `dependency-updater.json`
2. Rename to `dependency-updater-node.json`
3. Update commands:
   ```javascript
   "commands": [
     "npm audit",
     "npm outdated --json"
   ]
   ```
4. Adjust update logic for npm

### Add Docker Health Checks

Add to health-check-monitor.json:

```javascript
// In "Call Warp Health Check" node
{
  "checks": "tests,linting,docker,dependencies,containers"
}
```

Implement container health check:
```bash
docker ps --filter "health=unhealthy"
```

### Add Performance Monitoring

Create new workflow `performance-monitor.json`:
- Track build times
- Monitor test execution speed
- Detect performance regressions

---

## Integration with Governance

### Autonomous Operations

These workflows enable:
- **Level 3 → Level 4 autonomy**
- Self-monitoring without user intervention
- Automated fixes for known issues
- Continuous learning from errors

### Feedback Loop

```
Workflow detects issue
     ↓
Creates GitHub issue
     ↓
Claude reviews pattern
     ↓
Proposes template update
     ↓
User approves
     ↓
Warp updates templates
     ↓
All new projects benefit
```

---

## Metrics

Track these KPIs:

### Health Check Monitor
- **Uptime:** % of checks passing
- **MTTR:** Mean time to resolution
- **False positives:** Issues that aren't real problems

### Dependency Updater
- **Patches applied:** Count per week
- **Manual reviews:** Count per month
- **Update lag:** Days behind latest

### Error Log Aggregator
- **Patterns detected:** Count per week
- **Template improvements:** Count per quarter
- **Error recurrence:** % decrease over time

---

## Next Steps

### Phase 3 Completion:
- [x] Health check workflow created
- [x] Dependency updater workflow created
- [x] Error aggregator workflow created
- [ ] Deploy webhooks to n8n
- [ ] Activate workflows
- [ ] Monitor for 1 week
- [ ] Adjust schedules based on results

### Phase 4: Self-Improvement
- [ ] Pattern detection algorithms
- [ ] Automated template updates
- [ ] Migration scripts
- [ ] Performance metrics

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-09  
**Next Review:** 2026-02-09

---

**Co-Authored-By: Warp <agent@warp.dev>**
