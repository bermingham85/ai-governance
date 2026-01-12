# Autonomous System Activation & Monitoring Guide

**Status:** Ready for activation  
**Last Updated:** 2026-01-09

---

## Current State

✅ **Foundation Complete:**
- 41 projects have governance files (WARP.md, ERROR_LOG.md)
- 35 projects have Docker setup
- Templates ready in ai-governance/templates/
- n8n workflows designed but not yet deployed

❌ **Automation Not Active:**
- Workflows need to be imported to n8n
- Scheduled triggers not running
- No automated monitoring yet

---

## Activation Steps

### Step 1: Deploy n8n Workflows (5 minutes)

**Import workflows to n8n:**

```powershell
# Open n8n
Start-Process "http://192.168.50.246:5678"

# Workflows to import (from ai-governance/n8n-workflows/):
# 1. health-check-monitor.json          - Monitors project health every 6 hours
# 2. dependency-updater.json            - Updates dependencies weekly
# 3. error-log-aggregator.json          - Detects patterns daily
# 4. project-completion-orchestrator.json - On-demand project completion
```

**Import process:**
1. Open n8n: http://192.168.50.246:5678
2. Click **Workflows** → **Import from File**
3. Select each `.json` file
4. Click **Activate** toggle for each workflow

---

### Step 2: Configure Webhooks (10 minutes)

Create these webhook endpoints in n8n:

#### Webhook 1: `/webhook/warp-health-check`
**Purpose:** Execute health checks via Warp MCP

**Setup:**
```
1. New Workflow → Add Webhook node
2. Set path: /webhook/warp-health-check
3. Method: POST
4. Add Function node to process health checks:
```

```javascript
// Health check logic
const { project_path, checks } = $json;
const commands = [];

if (checks.includes('tests')) {
  commands.push('pytest');
}
if (checks.includes('linting')) {
  commands.push('ruff check .');
}
if (checks.includes('docker')) {
  commands.push('docker build -t test .');
}

// Execute and return status
return {
  status: allPassed ? 'healthy' : 'failed',
  failures: failedChecks
};
```

#### Webhook 2: `/webhook/warp-execute`
**Purpose:** Execute arbitrary commands

**Setup:**
```
1. Webhook node: /webhook/warp-execute
2. HTTP Request node → Warp MCP endpoint
3. Parse results and return
```

#### Webhook 3: `/webhook/create-github-issue`
**Purpose:** Create issues for failures

**Setup:**
```
1. Webhook: /webhook/create-github-issue
2. GitHub node → Create Issue
3. Use GitHub token from credentials
```

---

### Step 3: Test Workflows (5 minutes)

**Test each workflow manually:**

```powershell
# 1. Test Health Check Monitor
Invoke-WebRequest -Method POST `
  -Uri "http://192.168.50.246:5678/webhook-test/health-check-monitor" `
  -ContentType "application/json"

# 2. Test Dependency Updater
Invoke-WebRequest -Method POST `
  -Uri "http://192.168.50.246:5678/webhook-test/dependency-updater"

# 3. Test Error Aggregator
Invoke-WebRequest -Method POST `
  -Uri "http://192.168.50.246:5678/webhook-test/error-aggregator"
```

**Expected results:**
- Workflows execute without errors
- Check n8n execution logs
- Verify output data

---

## Monitoring - Real-Time

### Option 1: n8n Dashboard

**View active workflows:**
```
http://192.168.50.246:5678/workflows
```

**What to check:**
- ✅ Green toggle = Active
- 📊 Execution count
- ⏱️ Last execution time
- ❌ Error count

**View execution history:**
```
http://192.168.50.246:5678/executions
```

**What to look for:**
- ✅ Success rate
- 🔴 Failed executions
- ⏱️ Duration trends

---

### Option 2: PowerShell Status Check

```powershell
# Quick status script
$n8nUrl = "http://192.168.50.246:5678/api/v1"

# Check if n8n is running
try {
    $response = Invoke-WebRequest -Uri "$n8nUrl/workflows" -UseBasicParsing
    Write-Output "✅ n8n is running"
    
    # Get workflow status (requires API key)
    # $workflows = (Invoke-RestMethod -Uri "$n8nUrl/workflows").data
    # foreach ($wf in $workflows) {
    #     Write-Output "$($wf.name): $($wf.active ? 'Active' : 'Inactive')"
    # }
} catch {
    Write-Output "❌ n8n is not accessible"
}
```

---

### Option 3: Check Project Health Directly

```powershell
# Check if projects are being monitored
$recentChecks = Get-ChildItem -Path C:\Users\bermi\Projects -Recurse -Filter "ERROR_LOG.md" | 
    Where-Object { $_.LastWriteTime -gt (Get-Date).AddHours(-6) }

Write-Output "Projects checked in last 6 hours: $($recentChecks.Count)"

# Check for automated commits
Get-ChildItem -Path C:\Users\bermi\Projects -Directory |
    Where-Object { Test-Path "$($_.FullName)\.git" } |
    ForEach-Object {
        $lastCommit = git -C $_.FullName log -1 --format="%cr - %s" 2>$null
        if ($lastCommit -like "*Co-Authored-By: Warp*") {
            Write-Output "✓ $($_.Name): $lastCommit"
        }
    }
```

---

## Monitoring - What's Happening

### Health Check Monitor (Every 6 hours)

**Active when you see:**
```
✅ GitHub issues created for failures
✅ ERROR_LOG.md files updated
✅ n8n execution logs every 6 hours
✅ Projects with failed tests flagged
```

**Check manually:**
```powershell
# See if health checks ran
$sixHoursAgo = (Get-Date).AddHours(-6)
Get-ChildItem C:\Users\bermi\Projects -Recurse -Filter ".health-check" |
    Where-Object { $_.LastWriteTime -gt $sixHoursAgo }
```

---

### Dependency Updater (Weekly - Sunday 2 AM)

**Active when you see:**
```
✅ Auto-commits with "chore: security patch"
✅ GitHub issues for non-security updates
✅ Package updates applied automatically
✅ Tests run after updates
```

**Check manually:**
```powershell
# See recent dependency commits
Get-ChildItem -Path C:\Users\bermi\Projects -Directory |
    Where-Object { Test-Path "$($_.FullName)\.git" } |
    ForEach-Object {
        $commits = git -C $_.FullName log --since="1 week ago" --grep="chore: security patch" --oneline
        if ($commits) {
            Write-Output "✓ $($_.Name): $commits"
        }
    }
```

---

### Error Aggregator (Daily - 11 PM)

**Active when you see:**
```
✅ KNOWN_ERRORS.md updated
✅ Claude analysis requests
✅ Template improvements proposed
✅ Error patterns detected
```

**Check manually:**
```powershell
# See if patterns detected
$yesterday = (Get-Date).AddDays(-1)
if ((Test-Path "C:\Users\bermi\Projects\ai-governance\KNOWN_ERRORS.md") -and 
    ((Get-Item "C:\Users\bermi\Projects\ai-governance\KNOWN_ERRORS.md").LastWriteTime -gt $yesterday)) {
    Write-Output "✅ Error patterns analyzed in last 24h"
    Get-Content "C:\Users\bermi\Projects\ai-governance\KNOWN_ERRORS.md" -Tail 10
}
```

---

## Indicators of Active Improvement

### 1. Error Learning (Check Weekly)

```powershell
# Count errors logged this week
$thisWeek = (Get-Date).AddDays(-7)
$errorLogs = Get-ChildItem -Path C:\Users\bermi\Projects -Recurse -Filter "ERROR_LOG.md"

$recentErrors = 0
foreach ($log in $errorLogs) {
    if ($log.LastWriteTime -gt $thisWeek) {
        $recentErrors++
    }
}

Write-Output "📊 Error logs updated this week: $recentErrors"
Write-Output "📈 System is learning from: $recentErrors projects"
```

### 2. Automated Fixes (Check Daily)

```powershell
# Check for auto-commits
$today = Get-Date
$autoCommits = Get-ChildItem -Path C:\Users\bermi\Projects -Directory |
    Where-Object { Test-Path "$($_.FullName)\.git" } |
    ForEach-Object {
        git -C $_.FullName log --since="24 hours ago" --grep="Co-Authored-By: Warp" --oneline
    } | Measure-Object -Line

Write-Output "🤖 Auto-commits in last 24h: $($autoCommits.Lines)"
```

### 3. Security Patches (Check Weekly)

```powershell
# Check security patch commits
$lastWeek = (Get-Date).AddDays(-7)
Get-ChildItem -Path C:\Users\bermi\Projects -Directory |
    ForEach-Object {
        $patches = git -C $_.FullName log --since="1 week ago" --grep="security patch" --oneline
        if ($patches) {
            Write-Output "🔒 $($_.Name): Security patches applied"
        }
    }
```

### 4. Health Trends (Check Monthly)

```powershell
# Create simple health dashboard
$projects = Get-ChildItem -Path C:\Users\bermi\Projects -Directory | 
    Where-Object { Test-Path "$($_.FullName)\.git" }

$stats = @{
    Total = $projects.Count
    WithTests = 0
    WithDocker = 0
    WithCI = 0
}

foreach ($proj in $projects) {
    $path = $proj.FullName
    if (Test-Path "$path\tests") { $stats.WithTests++ }
    if (Test-Path "$path\Dockerfile") { $stats.WithDocker++ }
    if (Test-Path "$path\.github\workflows") { $stats.WithCI++ }
}

Write-Output @"
📊 PROJECT HEALTH DASHBOARD
━━━━━━━━━━━━━━━━━━━━━━━━━
Total Projects:     $($stats.Total)
With Tests:         $($stats.WithTests) ($([math]::Round($stats.WithTests/$stats.Total*100))%)
With Docker:        $($stats.WithDocker) ($([math]::Round($stats.WithDocker/$stats.Total*100))%)
With CI/CD:         $($stats.WithCI) ($([math]::Round($stats.WithCI/$stats.Total*100))%)
"@
```

---

## Quick Start: Activate NOW

```powershell
# 1. Check n8n is running
Start-Process "http://192.168.50.246:5678"

# 2. Import workflows
Write-Output @"
Import these files from:
C:\Users\bermi\Projects\ai-governance\n8n-workflows\

1. health-check-monitor.json
2. dependency-updater.json
3. error-log-aggregator.json

Then activate each one.
"@

# 3. Wait for first execution (6 hours for health check)

# 4. Check logs
Start-Process "http://192.168.50.246:5678/executions"
```

---

## Validation Checklist

After activation, verify within 24 hours:

- [ ] n8n workflows show "Active" (green toggle)
- [ ] Health check has executed at least once
- [ ] No execution errors in n8n logs
- [ ] ERROR_LOG.md files being updated
- [ ] At least 1 auto-commit visible
- [ ] GitHub issues created (if any failures)

If all checked: **System is autonomously operating!** ✅

---

## Troubleshooting

### Workflows not executing

**Check:**
```powershell
# Is n8n running?
Test-NetConnection -ComputerName 192.168.50.246 -Port 5678

# Are workflows activated?
# → Open n8n UI and check toggles
```

### No auto-commits appearing

**Possible reasons:**
1. No issues detected (good!)
2. Security patches policy (only applies if vulnerabilities found)
3. Workflows not yet executed (check schedule)

**Verify:**
```powershell
# Force a dependency check manually
cd C:\Users\bermi\Projects\chatgpt-mcp-server
uv run pip-audit
uv run pip list --outdated
```

### ERROR_LOG.md not updating

**Check:**
- Projects need actual errors to log
- Error aggregator runs daily at 11 PM
- Check n8n execution logs for aggregator workflow

---

## Dashboard Setup (Optional)

Create a simple monitoring dashboard:

```powershell
# Save as: monitor.ps1
while ($true) {
    Clear-Host
    Write-Output "═══════════════════════════════════════════"
    Write-Output "  AUTONOMOUS SYSTEM MONITOR"
    Write-Output "═══════════════════════════════════════════"
    Write-Output ""
    
    # n8n Status
    try {
        Invoke-WebRequest -Uri "http://192.168.50.246:5678" -TimeoutSec 2 -UseBasicParsing | Out-Null
        Write-Output "✅ n8n: Running"
    } catch {
        Write-Output "❌ n8n: Not responding"
    }
    
    # Recent auto-commits
    $recentCommits = 0
    Get-ChildItem -Path C:\Users\bermi\Projects -Directory | Select-Object -First 5 |
        ForEach-Object {
            $commits = git -C $_.FullName log --since="24 hours ago" --grep="Co-Authored-By: Warp" --oneline 2>$null
            if ($commits) { $recentCommits++ }
        }
    Write-Output "🤖 Auto-commits (24h): $recentCommits"
    
    # Last updated ERROR_LOG
    $recentLogs = Get-ChildItem -Path C:\Users\bermi\Projects -Recurse -Filter "ERROR_LOG.md" |
        Where-Object { $_.LastWriteTime -gt (Get-Date).AddHours(-6) } |
        Measure-Object
    Write-Output "📝 Error logs updated (6h): $($recentLogs.Count)"
    
    Write-Output ""
    Write-Output "Last updated: $(Get-Date -Format 'HH:mm:ss')"
    Write-Output "Press Ctrl+C to exit"
    
    Start-Sleep -Seconds 30
}
```

Run with: `.\monitor.ps1`

---

## Next Steps

1. **Activate workflows** in n8n (5 min)
2. **Wait 24 hours** for first full cycle
3. **Check indicators** using scripts above
4. **Review n8n executions** for any issues
5. **Enjoy autonomous operations!**

---

**Status:** Ready for activation  
**Documentation:** Complete  
**Support:** All scripts provided above

---

**Co-Authored-By: Warp <agent@warp.dev>**
