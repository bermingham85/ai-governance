# n8n Migration Script - Export from QNAP, Import to Docker
# Usage: .\migrate-n8n.ps1

param(
    [string]$QnapUrl = "http://192.168.50.246:5678",
    [string]$QnapApiKey = "",
    [string]$ExportDir = ".\n8n-export"
)

Write-Host "=== n8n Migration Script ===" -ForegroundColor Cyan
Write-Host ""

# Create export directory
New-Item -Path $ExportDir -ItemType Directory -Force | Out-Null

if (-not $QnapApiKey) {
    Write-Host "To export workflows, you need an API key from your QNAP n8n:" -ForegroundColor Yellow
    Write-Host "1. Go to $QnapUrl/settings/api" -ForegroundColor Yellow
    Write-Host "2. Create an API key" -ForegroundColor Yellow
    Write-Host "3. Run: .\migrate-n8n.ps1 -QnapApiKey 'your_key_here'" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Alternatively, manually export:" -ForegroundColor Yellow
    Write-Host "1. Go to $QnapUrl" -ForegroundColor Yellow
    Write-Host "2. Select all workflows" -ForegroundColor Yellow
    Write-Host "3. Click 'Download' and save to $ExportDir\workflows.json" -ForegroundColor Yellow
    exit 0
}

Write-Host "Exporting workflows from QNAP n8n..." -ForegroundColor Green

try {
    # Export workflows
    $headers = @{
        "X-N8N-API-KEY" = $QnapApiKey
        "Accept" = "application/json"
    }
    
    $workflows = Invoke-RestMethod -Uri "$QnapUrl/api/v1/workflows" -Headers $headers -Method Get
    $workflows | ConvertTo-Json -Depth 100 | Out-File "$ExportDir\workflows.json" -Encoding UTF8
    
    Write-Host "✓ Exported $($workflows.data.Count) workflows" -ForegroundColor Green
    
    # Export credentials (metadata only - secrets need manual re-entry)
    try {
        $credentials = Invoke-RestMethod -Uri "$QnapUrl/api/v1/credentials" -Headers $headers -Method Get
        $credentials | ConvertTo-Json -Depth 100 | Out-File "$ExportDir\credentials.json" -Encoding UTF8
        Write-Host "✓ Exported credential metadata (secrets need manual setup)" -ForegroundColor Yellow
    } catch {
        Write-Host "⚠ Could not export credentials: $_" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "Export complete! Files saved to: $ExportDir" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Copy .env.template to .env and configure" -ForegroundColor White
    Write-Host "2. Run: docker-compose up -d" -ForegroundColor White
    Write-Host "3. Go to http://localhost:5678 and set up your account" -ForegroundColor White
    Write-Host "4. Import workflows from $ExportDir\workflows.json" -ForegroundColor White
    Write-Host "5. Re-configure credentials" -ForegroundColor White
    
} catch {
    Write-Host "✗ Export failed: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Manual export required - see instructions above" -ForegroundColor Yellow
}
