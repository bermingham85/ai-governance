param([string]$ApiKey, [string]$WorkflowFile = ".\n8n-export\workflows.json")
$workflows = Get-Content $WorkflowFile | ConvertFrom-Json
$headers = @{"X-N8N-API-KEY" = $ApiKey; "Content-Type" = "application/json"}
$imported = 0
$failed = 0
foreach ($wf in $workflows.data) {
    try {
        $data = $wf | ConvertTo-Json -Depth 100 -Compress
        Invoke-RestMethod -Uri "http://localhost:5678/api/v1/workflows" -Method POST -Headers $headers -Body $data | Out-Null
        Write-Host "✓ $($wf.name)" -ForegroundColor Green
        $imported++
    } catch {
        Write-Host "✗ $($wf.name)" -ForegroundColor Red
        $failed++
    }
}
Write-Host "`nImported: $imported | Failed: $failed"
