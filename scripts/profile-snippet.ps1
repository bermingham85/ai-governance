# AI Governance Auto-Load
# Add this to your PowerShell profile: $PROFILE
# To edit profile: notepad $PROFILE

# Set governance path environment variable
$env:WARP_GOVERNANCE = "C:\Users\bermi\Projects\ai-governance\GLOBAL_AI_RULES.md"
$env:PROJECT_REGISTRY = "C:\Users\bermi\Projects\PROJECT_REGISTRY.md"
$env:DECISION_MATRIX = "C:\Users\bermi\Projects\ai-governance\guides\PROJECT_DECISION_MATRIX.md"

# Display governance reminder on startup
function Show-GovernanceReminder {
    Write-Host "`n┌────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
    Write-Host "│ " -NoNewline -ForegroundColor Cyan
    Write-Host "AI GOVERNANCE ACTIVE" -NoNewline -ForegroundColor Green
    Write-Host "                                 │" -ForegroundColor Cyan
    Write-Host "├────────────────────────────────────────────────────────┤" -ForegroundColor Cyan
    Write-Host "│ Rules: $env:WARP_GOVERNANCE │" -ForegroundColor White
    Write-Host "│ Registry: $env:PROJECT_REGISTRY       │" -ForegroundColor White
    Write-Host "│ Matrix: $env:DECISION_MATRIX │" -ForegroundColor White
    Write-Host "├────────────────────────────────────────────────────────┤" -ForegroundColor Cyan
    Write-Host "│ Before NEW projects: " -NoNewline -ForegroundColor Yellow
    Write-Host "Run pre-flight check             │" -ForegroundColor White
    Write-Host "│ Command: " -NoNewline -ForegroundColor Cyan
    Write-Host "C:\Users\bermi\Projects\ai-governance\scripts\pre-flight-check.ps1" -NoNewline -ForegroundColor Green
    Write-Host "  │" -ForegroundColor Cyan
    Write-Host "└────────────────────────────────────────────────────────┘`n" -ForegroundColor Cyan
}

# Show reminder (comment out if too verbose)
Show-GovernanceReminder

# Create convenient aliases
function Check-Governance {
    <#
    .SYNOPSIS
    Run pre-flight governance check
    
    .DESCRIPTION
    Validates compliance with ai-governance framework before project work
    
    .PARAMETER ProjectName
    Name of new project (if creating new)
    
    .PARAMETER NewProject
    Flag indicating this is a new project
    
    .EXAMPLE
    Check-Governance -NewProject -ProjectName "my-new-api"
    
    .EXAMPLE
    Check-Governance
    #>
    param(
        [string]$ProjectName,
        [switch]$NewProject,
        [switch]$Force
    )
    
    & "C:\Users\bermi\Projects\ai-governance\scripts\pre-flight-check.ps1" @PSBoundParameters
}

function Search-Registry {
    <#
    .SYNOPSIS
    Search PROJECT_REGISTRY.md for existing capabilities
    
    .PARAMETER Keyword
    Keyword to search for
    
    .EXAMPLE
    Search-Registry "agent"
    #>
    param([Parameter(Mandatory=$true)][string]$Keyword)
    
    if (Test-Path $env:PROJECT_REGISTRY) {
        Get-Content $env:PROJECT_REGISTRY | Select-String -Pattern $Keyword -Context 2
    } else {
        Write-Warning "PROJECT_REGISTRY.md not found at $env:PROJECT_REGISTRY"
    }
}

function Show-DecisionMatrix {
    <#
    .SYNOPSIS
    Open PROJECT_DECISION_MATRIX.md in editor
    #>
    if (Test-Path $env:DECISION_MATRIX) {
        code $env:DECISION_MATRIX  # Opens in VS Code
        # Alternatives: notepad $env:DECISION_MATRIX
    } else {
        Write-Warning "PROJECT_DECISION_MATRIX.md not found"
    }
}

function New-ProjectDecision {
    <#
    .SYNOPSIS
    Interactive wizard for new project decision
    
    .PARAMETER ProjectName
    Proposed project name
    
    .EXAMPLE
    New-ProjectDecision -ProjectName "payment-api"
    #>
    param([Parameter(Mandatory=$true)][string]$ProjectName)
    
    Write-Host "`n=== PROJECT DECISION WIZARD ===" -ForegroundColor Cyan
    Write-Host "Project: $ProjectName`n" -ForegroundColor White
    
    # Step 1: Search registry
    Write-Host "[STEP 1/8] Searching PROJECT_REGISTRY.md..." -ForegroundColor Yellow
    Search-Registry $ProjectName
    
    Write-Host "`nDoes similar capability already exist? (y/n): " -NoNewline -ForegroundColor Yellow
    $exists = Read-Host
    
    if ($exists -match '^y') {
        Write-Host "`n[STEP 2/8] Assessing extension feasibility..." -ForegroundColor Yellow
        Write-Host "Open DECISION_MATRIX Step 2 for scoring: $env:DECISION_MATRIX" -ForegroundColor Cyan
        Show-DecisionMatrix
    } else {
        Write-Host "`n[STEP 3/8] Evaluating integration opportunities..." -ForegroundColor Yellow
        Write-Host "Open DECISION_MATRIX Step 3 for checklist: $env:DECISION_MATRIX" -ForegroundColor Cyan
        Show-DecisionMatrix
    }
    
    Write-Host "`nContinue with full decision matrix manually." -ForegroundColor Green
    Write-Host "Document your decision in: C:\Users\bermi\Projects\ai-governance\adr\`n" -ForegroundColor Cyan
}

# Set aliases
Set-Alias -Name pgov -Value Check-Governance -Description "Pre-flight governance check"
Set-Alias -Name sreg -Value Search-Registry -Description "Search project registry"
Set-Alias -Name matrix -Value Show-DecisionMatrix -Description "Open decision matrix"
Set-Alias -Name newproj -Value New-ProjectDecision -Description "New project decision wizard"

# Export functions (if this is a module)
Export-ModuleMember -Function Check-Governance, Search-Registry, Show-DecisionMatrix, New-ProjectDecision
Export-ModuleMember -Alias pgov, sreg, matrix, newproj
