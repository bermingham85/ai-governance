# Install Governance Git Hooks Across All Projects
# Enforces RULE 12-16 at commit time

param(
    [string]$ProjectFilter = "*"
)

$ErrorActionPreference = "Stop"
$GovernanceRoot = "C:\Users\bermi\Projects\ai-governance"
$ProjectsRoot = "C:\Users\bermi\Projects"

Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  GOVERNANCE GIT HOOKS INSTALLER" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Create the pre-commit hook content
$PreCommitHook = @'
#!/usr/bin/env pwsh
# Governance Pre-Commit Hook
# Enforces RULE 12-16 before allowing commits

$ErrorActionPreference = "Stop"
$Red = "`e[91m"
$Yellow = "`e[93m"
$Green = "`e[92m"
$Reset = "`e[0m"

Write-Host "${Yellow}[Governance] Checking commit compliance...${Reset}"

# CHECK 1: Block .env files from being committed
$EnvFiles = git diff --cached --name-only --diff-filter=ACM | Select-String "\.env$"
if ($EnvFiles) {
    Write-Host "${Red}[VIOLATION] SECRETS_POLICY: Cannot commit .env files${Reset}"
    Write-Host "Blocked files:"
    $EnvFiles | ForEach-Object { Write-Host "  - $_" }
    Write-Host ""
    Write-Host "To fix: git reset HEAD $($EnvFiles -join ' ')"
    exit 1
}

# CHECK 2: Verify WARP.md exists (except for ai-governance repo)
$ProjectName = Split-Path -Leaf (git rev-parse --show-toplevel)
if ($ProjectName -ne "ai-governance") {
    $WarpFile = Join-Path (git rev-parse --show-toplevel) "WARP.md"
    if (-not (Test-Path $WarpFile)) {
        Write-Host "${Red}[VIOLATION] RULE 15: Project missing WARP.md${Reset}"
        Write-Host "Every project must have governance integration."
        Write-Host ""
        Write-Host "To fix: Run bootstrap script from ai-governance/scripts/"
        exit 1
    }
}

# CHECK 3: Detect potential RULE 14 violations (Claude executing)
$CommitMsg = git log -1 --pretty=%B HEAD 2>$null
if ($CommitMsg -match "Claude|GPT" -and $CommitMsg -notmatch "Co-Authored-By") {
    $StagedFiles = git diff --cached --name-only --diff-filter=ACM
    $HasExecutionFiles = $StagedFiles | Where-Object { $_ -match "\.(ps1|sh|bat|cmd)$|package\.json|Makefile" }
    
    if ($HasExecutionFiles) {
        Write-Host "${Yellow}[WARNING] Possible RULE 14 violation detected${Reset}"
        Write-Host "Commit appears to be from Claude with execution changes."
        Write-Host "RULE 14: Claude must not execute, only design."
        Write-Host ""
        Write-Host "If this was Warp executing Claude's design, add:"
        Write-Host "  Co-Authored-By: Claude <claude@anthropic.com>"
        Write-Host ""
        Write-Host "Continue anyway? (y/N): " -NoNewline
        $Response = Read-Host
        if ($Response -ne "y") {
            exit 1
        }
    }
}

# CHECK 4: Require co-author attribution for governance changes
$GovernanceFiles = git diff --cached --name-only --diff-filter=ACM | 
    Where-Object { $_ -match "GLOBAL_AI_RULES|CAPABILITIES|HANDOVER|SECRETS_POLICY|WARP\.md" }

if ($GovernanceFiles) {
    $CommitMsg = git log -1 --pretty=%B HEAD 2>$null
    if ($CommitMsg -notmatch "Co-Authored-By:.*Warp") {
        Write-Host "${Yellow}[WARNING] Governance file changes without Warp co-author${Reset}"
        Write-Host "Changed files:"
        $GovernanceFiles | ForEach-Object { Write-Host "  - $_" }
        Write-Host ""
        Write-Host "All governance changes should include:"
        Write-Host "  Co-Authored-By: Warp <agent@warp.dev>"
    }
}

Write-Host "${Green}[Governance] ✓ Commit approved${Reset}"
exit 0
'@

# Find all Git repositories
$Projects = Get-ChildItem -Path $ProjectsRoot -Directory | 
    Where-Object { 
        $_.Name -like $ProjectFilter -and 
        (Test-Path (Join-Path $_.FullName ".git"))
    }

Write-Host "Found $($Projects.Count) Git repositories" -ForegroundColor Green
Write-Host ""

$Installed = 0
$Skipped = 0
$Failed = 0

foreach ($Project in $Projects) {
    $HooksDir = Join-Path $Project.FullName ".git\hooks"
    $PreCommitPath = Join-Path $HooksDir "pre-commit"
    
    Write-Host "→ $($Project.Name): " -NoNewline
    
    try {
        # Create hooks directory if missing
        if (-not (Test-Path $HooksDir)) {
            New-Item -ItemType Directory -Path $HooksDir -Force | Out-Null
        }
        
        # Check if hook already exists
        if (Test-Path $PreCommitPath) {
            $Existing = Get-Content $PreCommitPath -Raw
            if ($Existing -match "Governance Pre-Commit Hook") {
                Write-Host "Already installed" -ForegroundColor Yellow
                $Skipped++
                continue
            }
        }
        
        # Install hook
        Set-Content -Path $PreCommitPath -Value $PreCommitHook -Encoding UTF8
        
        # Make executable (Git Bash compatibility)
        git -C $Project.FullName update-index --chmod=+x .git/hooks/pre-commit 2>$null
        
        Write-Host "Installed ✓" -ForegroundColor Green
        $Installed++
        
    } catch {
        Write-Host "Failed: $_" -ForegroundColor Red
        $Failed++
    }
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "INSTALLATION COMPLETE" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Installed: $Installed" -ForegroundColor Green
Write-Host "Skipped:   $Skipped" -ForegroundColor Yellow
Write-Host "Failed:    $Failed" -ForegroundColor $(if ($Failed -gt 0) { "Red" } else { "Gray" })
Write-Host ""
Write-Host "Git hooks now enforce:" -ForegroundColor Yellow
Write-Host "  ✓ SECRETS_POLICY: Block .env commits" -ForegroundColor Gray
Write-Host "  ✓ RULE 15: Require WARP.md in projects" -ForegroundColor Gray
Write-Host "  ✓ RULE 14: Detect Claude execution violations" -ForegroundColor Gray
Write-Host "  ✓ Co-author attribution for governance" -ForegroundColor Gray
