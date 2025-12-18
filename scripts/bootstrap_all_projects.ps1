# Governance Bootstrap - Apply to All Projects
# Executes STEP 1-10 for each project in C:\Users\bermi\Projects\

param(
    [switch]$DryRun = $false,
    [switch]$SkipClaude = $false,
    [string]$ProjectFilter = "*"
)

$ErrorActionPreference = "Stop"
$GovernanceRoot = "C:\Users\bermi\Projects\ai-governance"
$ProjectsRoot = "C:\Users\bermi\Projects"

# Projects to bootstrap
$Projects = Get-ChildItem -Path $ProjectsRoot -Directory | 
    Where-Object { 
        $_.Name -like $ProjectFilter -and 
        $_.Name -ne "ai-governance" -and
        (Test-Path (Join-Path $_.FullName ".git"))
    }

Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "    GOVERNANCE BOOTSTRAP - ALL PROJECTS" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Mode: $(if ($DryRun) { 'DRY RUN' } else { 'EXECUTE' })" -ForegroundColor Yellow
Write-Host "Projects Found: $($Projects.Count)" -ForegroundColor Green
Write-Host ""

foreach ($Project in $Projects) {
    Write-Host "───────────────────────────────────────────────────────" -ForegroundColor Gray
    Write-Host "PROJECT: $($Project.Name)" -ForegroundColor Cyan
    Write-Host "───────────────────────────────────────────────────────" -ForegroundColor Gray
    
    $ProjectPath = $Project.FullName
    
    # STEP 1: Check if WARP.md exists
    $WarpFile = Join-Path $ProjectPath "WARP.md"
    if (Test-Path $WarpFile) {
        Write-Host "✓ WARP.md exists - SKIPPING" -ForegroundColor Yellow
        continue
    }
    
    # STEP 2: Determine project type
    $ProjectType = "generic"
    if (Test-Path (Join-Path $ProjectPath "package.json")) {
        $ProjectType = "nodejs"
    } elseif (Test-Path (Join-Path $ProjectPath "requirements.txt")) {
        $ProjectType = "python"
    } elseif (Test-Path (Join-Path $ProjectPath "*.csproj")) {
        $ProjectType = "dotnet"
    }
    
    Write-Host "→ Project Type: $ProjectType" -ForegroundColor Gray
    
    # STEP 3-6: Create WARP.md with project-specific rules
    if (-not $DryRun) {
        $WarpContent = @"
# $($Project.Name) - Warp Rules

**Project Type:** $ProjectType
**Governance:** Follows GLOBAL_AI_RULES.md from ai-governance
**Last Updated:** $(Get-Date -Format "yyyy-MM-dd")

---

## Project-Specific Rules

### Technology Stack
"@

        if ($ProjectType -eq "nodejs") {
            $WarpContent += @"

- Node.js project
- Package manager: npm
- Config: package.json
- Install: ``npm install``
- Build: ``npm run build`` (if defined)
- Test: ``npm test`` (if defined)
"@
        } elseif ($ProjectType -eq "python") {
            $WarpContent += @"

- Python project
- Package manager: pip
- Config: requirements.txt
- Install: ``pip install -r requirements.txt``
- Test: ``pytest`` (if configured)
"@
        }

        $WarpContent += @"


### Protected Files
- .env (secrets)
- node_modules/ (dependencies)
- dist/ (build artifacts)
- .git/ (version control)

### Governance Integration
This project follows:
- GLOBAL_AI_RULES.md (RULE 12-15)
- CAPABILITIES_MANIFEST.md
- HANDOVER_PROTOCOL.md
- SECRETS_POLICY.md

**Source:** C:\Users\bermi\Projects\ai-governance

---

## Project Notes
<!-- Add project-specific context here -->

---

**Co-Authored-By: Warp <agent@warp.dev>**
"@

        Set-Content -Path $WarpFile -Value $WarpContent -Encoding UTF8
        Write-Host "✓ Created WARP.md" -ForegroundColor Green
        
        # STEP 7: Git operations
        Push-Location $ProjectPath
        try {
            git add WARP.md
            git commit -m "Add governance WARP.md for project-specific rules

Integrates with ai-governance framework:
- References GLOBAL_AI_RULES.md
- Follows HANDOVER_PROTOCOL.md
- Respects CAPABILITIES_MANIFEST.md

Co-Authored-By: Warp <agent@warp.dev>"
            
            Write-Host "✓ Committed WARP.md" -ForegroundColor Green
        } catch {
            Write-Host "✗ Git commit failed: $_" -ForegroundColor Red
        } finally {
            Pop-Location
        }
    } else {
        Write-Host "→ Would create WARP.md (dry run)" -ForegroundColor Gray
    }
    
    Write-Host ""
}

Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "BOOTSTRAP COMPLETE" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Projects processed: $($Projects.Count)" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Review generated WARP.md files" -ForegroundColor Gray
Write-Host "2. Push commits: foreach project { git push }" -ForegroundColor Gray
Write-Host "3. Verify governance integration" -ForegroundColor Gray
