param(
    [Parameter(ValueFromPipeline = $true)]
    [string]$InputObject
)

begin {
    $inputBuffer = New-Object System.Collections.Generic.List[string]
}

process {
    if ($null -ne $InputObject) {
        $inputBuffer.Add([string]$InputObject)
    }
}

end {
$inputJson = ($inputBuffer -join [Environment]::NewLine)
$payload = $null

if (-not [string]::IsNullOrWhiteSpace($inputJson)) {
    try {
        $payload = $inputJson | ConvertFrom-Json -Depth 20
    }
    catch {
        $payload = $null
    }
}

$toolName = ""
if ($payload) {
    if ($payload.PSObject.Properties.Name -contains "toolName") {
        $toolName = [string]$payload.toolName
    }
    elseif ($payload.PSObject.Properties.Name -contains "tool_name") {
        $toolName = [string]$payload.tool_name
    }
}

if ($toolName -ne "edit" -and $toolName -ne "create") {
    exit 0
}

$warnings = New-Object System.Collections.Generic.List[string]

$secretRegex = '(?i)(api[_-]?key|secret|password|token|connectionstring)\s*[:=]\s*["''][^"''\s]{8,}["'']'
$secretHits = Select-String -Path "*" -Pattern $secretRegex -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.Path -notmatch '\\(bin|obj|\.git)\\' }
if ($secretHits) {
    $warnings.Add("Potential hardcoded secret patterns found.")
}

$dbContextHits = Select-String -Path "Controllers/*.cs" -Pattern 'LMSDbContext|\bDbContext\b' -ErrorAction SilentlyContinue
if ($dbContextHits) {
    $warnings.Add("DbContext usage detected in Controllers. Prefer Service/Repository boundaries.")
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$logDir = Join-Path $repoRoot ".github/hooks/logs"
$warnFile = Join-Path $logDir "code-review-warnings.log"
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

if ($warnings.Count -gt 0) {
    $timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    Add-Content -Path $warnFile -Value "[$timestamp] postToolUse warnings for tool=$toolName" -Encoding UTF8
    foreach ($warning in $warnings) {
        Add-Content -Path $warnFile -Value "WARNING: $warning" -Encoding UTF8
        Write-Output "WARNING: $warning"
    }
    Add-Content -Path $warnFile -Value "" -Encoding UTF8
}

exit 0
}
