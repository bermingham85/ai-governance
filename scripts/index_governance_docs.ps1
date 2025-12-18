# RAG Indexing System for Governance Documents
# Indexes all governance files for AI context retrieval

param(
    [string]$OutputPath = "C:\Users\bermi\Projects\ai-governance\rag_index.json",
    [switch]$IncludeProjectWarp = $true
)

$ErrorActionPreference = "Stop"

Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  RAG GOVERNANCE INDEXING" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$Index = @{
    generated_at = (Get-Date -Format "o")
    version = "1.0.0"
    documents = @()
}

# Core governance documents
$CoreDocs = @(
    "C:\Users\bermi\Projects\ai-governance\README.md",
    "C:\Users\bermi\Projects\ai-governance\GLOBAL_AI_RULES.md",
    "C:\Users\bermi\Projects\ai-governance\CAPABILITIES_MANIFEST.md",
    "C:\Users\bermi\Projects\ai-governance\HANDOVER_PROTOCOL.md",
    "C:\Users\bermi\Projects\ai-governance\SECRETS_POLICY.md",
    "C:\Users\bermi\Projects\ai-governance\SECRET_ROTATION_LOG.md",
    "C:\Users\bermi\Projects\ai-governance\prompts\handover_claude_to_warp.md",
    "C:\Users\bermi\Projects\ai-governance\prompts\task_router.md",
    "C:\Users\bermi\Projects\ai-governance\prompts\handover_warp_to_claude_review.md"
)

Write-Host "→ Indexing core governance documents..." -ForegroundColor Yellow

foreach ($Doc in $CoreDocs) {
    if (Test-Path $Doc) {
        $Content = Get-Content $Doc -Raw
        $RelativePath = $Doc.Replace("C:\Users\bermi\Projects\ai-governance\", "")
        
        # Extract metadata
        $Lines = Get-Content $Doc
        $Title = ($Lines | Select-Object -First 1).TrimStart('#').Trim()
        
        # Calculate token estimate (rough: ~4 chars per token)
        $TokenEstimate = [math]::Ceiling($Content.Length / 4)
        
        $Index.documents += @{
            type = "governance"
            path = $Doc
            relative_path = $RelativePath
            title = $Title
            content = $Content
            size_bytes = $Content.Length
            token_estimate = $TokenEstimate
            indexed_at = (Get-Date -Format "o")
        }
        
        Write-Host "  ✓ $RelativePath ($TokenEstimate tokens)" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $Doc not found" -ForegroundColor Red
    }
}

# Project WARP.md files
if ($IncludeProjectWarp) {
    Write-Host ""
    Write-Host "→ Indexing project WARP.md files..." -ForegroundColor Yellow
    
    $Projects = Get-ChildItem -Path "C:\Users\bermi\Projects" -Directory | 
        Where-Object { (Test-Path (Join-Path $_.FullName "WARP.md")) }
    
    foreach ($Project in $Projects) {
        $WarpFile = Join-Path $Project.FullName "WARP.md"
        $Content = Get-Content $WarpFile -Raw
        $RelativePath = "projects\$($Project.Name)\WARP.md"
        
        $Lines = Get-Content $WarpFile
        $Title = ($Lines | Select-Object -First 1).TrimStart('#').Trim()
        $TokenEstimate = [math]::Ceiling($Content.Length / 4)
        
        $Index.documents += @{
            type = "project_rules"
            path = $WarpFile
            relative_path = $RelativePath
            project_name = $Project.Name
            title = $Title
            content = $Content
            size_bytes = $Content.Length
            token_estimate = $TokenEstimate
            indexed_at = (Get-Date -Format "o")
        }
        
        Write-Host "  ✓ $($Project.Name)/WARP.md ($TokenEstimate tokens)" -ForegroundColor Green
    }
}

# Calculate totals
$TotalDocs = $Index.documents.Count
$TotalTokens = ($Index.documents | Measure-Object -Property token_estimate -Sum).Sum
$TotalSize = ($Index.documents | Measure-Object -Property size_bytes -Sum).Sum

$Index.summary = @{
    total_documents = $TotalDocs
    total_tokens = $TotalTokens
    total_size_bytes = $TotalSize
    total_size_mb = [math]::Round($TotalSize / 1MB, 2)
    core_documents = ($Index.documents | Where-Object { $_.type -eq "governance" }).Count
    project_documents = ($Index.documents | Where-Object { $_.type -eq "project_rules" }).Count
}

# Save index
$Index | ConvertTo-Json -Depth 10 | Set-Content -Path $OutputPath -Encoding UTF8

Write-Host ""
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "INDEXING COMPLETE" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Documents indexed: $TotalDocs" -ForegroundColor Green
Write-Host "Total tokens: $([math]::Round($TotalTokens / 1000, 1))K" -ForegroundColor Green
Write-Host "Total size: $([math]::Round($TotalSize / 1KB, 1)) KB" -ForegroundColor Green
Write-Host ""
Write-Host "Index saved to: $OutputPath" -ForegroundColor Yellow
Write-Host ""
Write-Host "Usage:" -ForegroundColor Yellow
Write-Host "- Claude: Import rag_index.json as knowledge base" -ForegroundColor Gray
Write-Host "- Warp: Reference indexed documents by relative_path" -ForegroundColor Gray
Write-Host "- APIs: Parse JSON for semantic search/retrieval" -ForegroundColor Gray
