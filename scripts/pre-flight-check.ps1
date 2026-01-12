# Pre-Flight Governance Check
# Run this before ANY new project or major changes
# Ensures all governance rules are followed

param(
    [Parameter(Mandatory=$false)]
    [string]$ProjectName = "",
    
    [Parameter(Mandatory=$false)]
    [switch]$NewProject,
    
    [Parameter(Mandatory=$false)]
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Colors
function Write-Success { param($Message) Write-Host "[✓] $Message" -ForegroundColor Green }
function Write-Warning { param($Message) Write-Host "[!] $Message" -ForegroundColor Yellow }
function Write-Error { param($Message) Write-Host "[✗] $Message" -ForegroundColor Red }
function Write-Info { param($Message) Write-Host "[i] $Message" -ForegroundColor Cyan }

Write-Host "`n=== PRE-FLIGHT GOVERNANCE CHECK ===" -ForegroundColor Cyan
Write-Host "Validating compliance with ai-governance framework...`n" -ForegroundColor Cyan

$governancePath = "C:\Users\bermi\Projects\ai-governance"
$registryPath = "C:\Users\bermi\Projects\PROJECT_REGISTRY.md"
$violations = @()
$warnings = @()

# Check 1: Governance files exist
Write-Info "Checking governance files..."

$requiredFiles = @(
    @{Path="$governancePath\GLOBAL_AI_RULES.md"; Name="GLOBAL_AI_RULES.md"},
    @{Path="$governancePath\guides\PROJECT_DECISION_MATRIX.md"; Name="PROJECT_DECISION_MATRIX.md"},
    @{Path="$registryPath"; Name="PROJECT_REGISTRY.md"}
)

foreach ($file in $requiredFiles) {
    if (Test-Path $file.Path) {
        Write-Success "$($file.Name) found"
    } else {
        Write-Error "$($file.Name) NOT FOUND at $($file.Path)"
        $violations += "Missing required governance file: $($file.Name)"
    }
}

# Check 2: If new project, validate PROJECT_REGISTRY was consulted
if ($NewProject -and $ProjectName) {
    Write-Info "`nChecking project registry for duplicates..."
    
    if (Test-Path $registryPath) {
        $registryContent = Get-Content $registryPath -Raw
        
        # Search for similar project names
        $similarProjects = @()
        $keywords = $ProjectName -split '-|_' | Where-Object { $_.Length -gt 3 }
        
        foreach ($keyword in $keywords) {
            if ($registryContent -match "(?i)$keyword") {
                $matches = $registryContent | Select-String -Pattern "(?i)\*\*.*$keyword.*\*\*" -AllMatches
                foreach ($match in $matches.Matches) {
                    $similarProjects += $match.Value
                }
            }
        }
        
        if ($similarProjects.Count -gt 0) {
            Write-Warning "Found potentially related existing projects:"
            $similarProjects | Select-Object -Unique | ForEach-Object {
                Write-Host "  - $_" -ForegroundColor Yellow
            }
            $warnings += "Similar projects exist - verify decision matrix was completed"
            
            if (-not $Force) {
                Write-Host "`nDid you complete the PROJECT_DECISION_MATRIX 8-step process? (y/n): " -NoNewline -ForegroundColor Yellow
                $response = Read-Host
                if ($response -notmatch '^y(es)?$') {
                    Write-Error "PROJECT_DECISION_MATRIX not completed"
                    $violations += "User confirmed decision matrix was not completed"
                }
            }
        } else {
            Write-Success "No obvious duplicates found"
        }
    }
}

# Check 3: Verify git configuration
Write-Info "`nChecking Git configuration..."

try {
    $gitUser = git config user.name 2>$null
    $gitEmail = git config user.email 2>$null
    
    if ($gitUser -and $gitEmail) {
        Write-Success "Git configured: $gitUser <$gitEmail>"
    } else {
        Write-Warning "Git not fully configured"
        $warnings += "Git user/email not configured"
    }
} catch {
    Write-Warning "Git not available or not configured"
    $warnings += "Git not available"
}

# Check 4: Verify GitHub CLI available
Write-Info "Checking GitHub CLI..."

try {
    $ghVersion = gh --version 2>$null
    if ($ghVersion) {
        Write-Success "GitHub CLI available"
    }
} catch {
    Write-Warning "GitHub CLI (gh) not available - repo creation will require manual steps"
    $warnings += "GitHub CLI not available"
}

# Check 5: Check if in correct directory structure
Write-Info "Checking directory structure..."

$currentPath = Get-Location
if ($currentPath.Path -like "*\Projects\*") {
    Write-Success "In correct Projects directory structure"
} else {
    Write-Warning "Not in standard C:\Users\bermi\Projects\ structure"
    $warnings += "Non-standard directory location"
}

# Check 6: Verify WARP.md exists in project (if not new)
if (-not $NewProject -and (Test-Path ".git")) {
    Write-Info "Checking for project WARP.md..."
    
    if (Test-Path "WARP.md") {
        Write-Success "WARP.md exists"
    } else {
        Write-Warning "WARP.md missing (required per RULE 14)"
        $warnings += "Missing WARP.md in project"
    }
}

# Check 7: Environment variable check
Write-Info "Checking environment variables..."

if ($env:WARP_GOVERNANCE) {
    Write-Success "WARP_GOVERNANCE environment variable set: $env:WARP_GOVERNANCE"
} else {
    Write-Warning "WARP_GOVERNANCE environment variable not set"
    $warnings += "Environment variable not configured"
}

# Summary
Write-Host "`n=== PRE-FLIGHT CHECK SUMMARY ===" -ForegroundColor Cyan

if ($violations.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Success "`nALL CHECKS PASSED ✓"
    Write-Host "You may proceed with the project work.`n" -ForegroundColor Green
    exit 0
}

if ($violations.Count -gt 0) {
    Write-Host "`nCRITICAL VIOLATIONS:" -ForegroundColor Red
    $violations | ForEach-Object { Write-Error $_ }
    Write-Host "`nCANNOT PROCEED - Fix violations first`n" -ForegroundColor Red
    exit 1
}

if ($warnings.Count -gt 0) {
    Write-Host "`nWARNINGS:" -ForegroundColor Yellow
    $warnings | ForEach-Object { Write-Warning $_ }
    
    if (-not $Force) {
        Write-Host "`nProceed anyway? (y/n): " -NoNewline -ForegroundColor Yellow
        $response = Read-Host
        if ($response -notmatch '^y(es)?$') {
            Write-Host "Aborted by user`n" -ForegroundColor Yellow
            exit 1
        }
    }
    
    Write-Success "`nProceeding with warnings acknowledged`n"
    exit 0
}

# Reminder
Write-Host "`n=== QUICK REFERENCE ===" -ForegroundColor Cyan
Write-Host "Before creating NEW project:"
Write-Host "  1. Search: C:\Users\bermi\Projects\PROJECT_REGISTRY.md" -ForegroundColor White
Write-Host "  2. Search: gh repo list bermingham85 --limit 100" -ForegroundColor White
Write-Host "  3. Follow: PROJECT_DECISION_MATRIX.md 8-step process" -ForegroundColor White
Write-Host "  4. Document: Create ADR in ai-governance/adr/" -ForegroundColor White
Write-Host "  5. Update: Add to PROJECT_REGISTRY.md after creation`n" -ForegroundColor White
