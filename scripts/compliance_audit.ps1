# Governance Compliance Audit System
# Verifies all projects follow governance rules

param(
    [switch]$Fix = $false,
    [switch]$Verbose = $false
)

$ErrorActionPreference = "Stop"
$ProjectsRoot = "C:\Users\bermi\Projects"
$GovernanceRoot = "C:\Users\bermi\Projects\ai-governance"

Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  GOVERNANCE COMPLIANCE AUDIT" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Mode: $(if ($Fix) { 'FIX ISSUES' } else { 'AUDIT ONLY' })" -ForegroundColor Yellow
Write-Host ""

$Results = @{
    timestamp = (Get-Date -Format "o")
    projects_scanned = 0
    issues_found = 0
    issues_fixed = 0
    checks = @{
        warp_md_exists = @{ passed = 0; failed = @() }
        warp_md_valid = @{ passed = 0; failed = @() }
        secrets_in_commits = @{ passed = 0; failed = @() }
        git_initialized = @{ passed = 0; failed = @() }
        gitignore_protects_secrets = @{ passed = 0; failed = @() }
    }
}

$Projects = Get-ChildItem -Path $ProjectsRoot -Directory | 
    Where-Object { $_.Name -ne "ai-governance" }

foreach ($Project in $Projects) {
    $Results.projects_scanned++
    $ProjectPath = $Project.FullName
    
    Write-Host "→ $($Project.Name)" -ForegroundColor Cyan
    
    # CHECK 1: Git initialized
    if (-not (Test-Path (Join-Path $ProjectPath ".git"))) {
        Write-Host "  ✗ No Git repository" -ForegroundColor Red
        $Results.checks.git_initialized.failed += $Project.Name
        $Results.issues_found++
        
        if ($Fix) {
            Push-Location $ProjectPath
            git init
            git add .
            git commit -m "Initial commit - governance compliance

Co-Authored-By: Warp <agent@warp.dev>"
            Pop-Location
            Write-Host "    → Fixed: Git initialized" -ForegroundColor Green
            $Results.issues_fixed++
        }
    } else {
        $Results.checks.git_initialized.passed++
    }
    
    # CHECK 2: WARP.md exists
    $WarpFile = Join-Path $ProjectPath "WARP.md"
    if (-not (Test-Path $WarpFile)) {
        Write-Host "  ✗ WARP.md missing" -ForegroundColor Red
        $Results.checks.warp_md_exists.failed += $Project.Name
        $Results.issues_found++
        
        if ($Fix) {
            Write-Host "    → Use bootstrap script to create" -ForegroundColor Yellow
        }
    } else {
        $Results.checks.warp_md_exists.passed++
        
        # CHECK 3: WARP.md references governance
        $WarpContent = Get-Content $WarpFile -Raw
        if ($WarpContent -notmatch "ai-governance" -or $WarpContent -notmatch "GLOBAL_AI_RULES") {
            Write-Host "  ✗ WARP.md doesn't reference governance" -ForegroundColor Red
            $Results.checks.warp_md_valid.failed += $Project.Name
            $Results.issues_found++
        } else {
            $Results.checks.warp_md_valid.passed++
        }
    }
    
    # CHECK 4: .gitignore protects secrets
    $GitignoreFile = Join-Path $ProjectPath ".gitignore"
    if (Test-Path $GitignoreFile) {
        $GitignoreContent = Get-Content $GitignoreFile -Raw
        if ($GitignoreContent -notmatch "\.env") {
            Write-Host "  ✗ .gitignore doesn't protect .env" -ForegroundColor Red
            $Results.checks.gitignore_protects_secrets.failed += $Project.Name
            $Results.issues_found++
            
            if ($Fix) {
                Add-Content -Path $GitignoreFile -Value "`n# Secrets`n.env`n.env.*`n*.key`n*.pem"
                Write-Host "    → Fixed: Added .env to .gitignore" -ForegroundColor Green
                $Results.issues_fixed++
            }
        } else {
            $Results.checks.gitignore_protects_secrets.passed++
        }
    }
    
    # CHECK 5: No secrets in commits (scan .env files)
    if (Test-Path (Join-Path $ProjectPath ".git")) {
        Push-Location $ProjectPath
        try {
            $status = git status --porcelain 2>&1 | Select-String "\.env"
            if ($status) {
                Write-Host "  ⚠  Uncommitted .env file detected" -ForegroundColor Yellow
                $Results.checks.secrets_in_commits.failed += $Project.Name
                $Results.issues_found++
            } else {
                $Results.checks.secrets_in_commits.passed++
            }
        } finally {
            Pop-Location
        }
    }
    
    if ($Verbose) {
        Write-Host ""
    }
}

# Summary
Write-Host ""
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "AUDIT SUMMARY" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Projects scanned: $($Results.projects_scanned)" -ForegroundColor Green
Write-Host "Issues found: $($Results.issues_found)" -ForegroundColor $(if ($Results.issues_found -gt 0) { "Red" } else { "Green" })
if ($Fix) {
    Write-Host "Issues fixed: $($Results.issues_fixed)" -ForegroundColor Green
}
Write-Host ""

Write-Host "Check Results:" -ForegroundColor Yellow
Write-Host "  Git initialized: $($Results.checks.git_initialized.passed)/$($Results.projects_scanned) passed" -ForegroundColor $(if ($Results.checks.git_initialized.failed.Count -eq 0) { "Green" } else { "Yellow" })
Write-Host "  WARP.md exists: $($Results.checks.warp_md_exists.passed)/$($Results.projects_scanned) passed" -ForegroundColor $(if ($Results.checks.warp_md_exists.failed.Count -eq 0) { "Green" } else { "Yellow" })
Write-Host "  WARP.md valid: $($Results.checks.warp_md_valid.passed)/$($Results.checks.warp_md_exists.passed) passed" -ForegroundColor $(if ($Results.checks.warp_md_valid.failed.Count -eq 0) { "Green" } else { "Yellow" })
Write-Host "  .gitignore protects secrets: $($Results.checks.gitignore_protects_secrets.passed)/$($Results.projects_scanned) passed" -ForegroundColor $(if ($Results.checks.gitignore_protects_secrets.failed.Count -eq 0) { "Green" } else { "Yellow" })
Write-Host "  No uncommitted secrets: $($Results.checks.secrets_in_commits.passed)/$($Results.projects_scanned) passed" -ForegroundColor $(if ($Results.checks.secrets_in_commits.failed.Count -eq 0) { "Green" } else { "Yellow" })

# Save report
$ReportPath = Join-Path $GovernanceRoot "compliance_report.json"
$Results | ConvertTo-Json -Depth 10 | Set-Content -Path $ReportPath -Encoding UTF8
Write-Host ""
Write-Host "Report saved to: $ReportPath" -ForegroundColor Yellow

if ($Results.issues_found -gt 0 -and -not $Fix) {
    Write-Host ""
    Write-Host "To fix issues automatically, run with -Fix flag" -ForegroundColor Yellow
}
