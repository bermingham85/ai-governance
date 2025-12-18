# Push all pending commits across projects

$ProjectsRoot = "C:\Users\bermi\Projects"
$Projects = Get-ChildItem -Path $ProjectsRoot -Directory | Where-Object { Test-Path (Join-Path $_.FullName ".git") }

Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  PUSH ALL COMMITS TO GITHUB" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$Pushed = 0
$Skipped = 0
$Failed = 0

foreach ($Project in $Projects) {
    Push-Location $Project.FullName
    
    try {
        # Check if there are commits to push
        $status = git status --porcelain --branch 2>&1
        if ($status -match "ahead") {
            Write-Host "→ $($Project.Name): Pushing..." -ForegroundColor Yellow
            git push 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  ✓ Pushed" -ForegroundColor Green
                $Pushed++
            } else {
                Write-Host "  ✗ Push failed" -ForegroundColor Red
                $Failed++
            }
        } else {
            Write-Host "→ $($Project.Name): Up to date" -ForegroundColor Gray
            $Skipped++
        }
    } catch {
        Write-Host "  ✗ Error: $_" -ForegroundColor Red
        $Failed++
    } finally {
        Pop-Location
    }
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "SUMMARY" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "Pushed:  $Pushed" -ForegroundColor Green
Write-Host "Skipped: $Skipped" -ForegroundColor Gray
Write-Host "Failed:  $Failed" -ForegroundColor $(if ($Failed -gt 0) { "Red" } else { "Gray" })
