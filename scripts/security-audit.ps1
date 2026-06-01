param(
    [string]$Phase = "event",
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

$toolName = "unknown"
if ($payload) {
    if ($payload.PSObject.Properties.Name -contains "toolName" -and $payload.toolName) {
        $toolName = [string]$payload.toolName
    }
    elseif ($payload.PSObject.Properties.Name -contains "tool_name" -and $payload.tool_name) {
        $toolName = [string]$payload.tool_name
    }
}

$status = "unknown"
if ($payload) {
    if ($payload.PSObject.Properties.Name -contains "toolResult" -and $payload.toolResult) {
        if ($payload.toolResult.PSObject.Properties.Name -contains "resultType" -and $payload.toolResult.resultType) {
            $status = [string]$payload.toolResult.resultType
        }
    }
    elseif ($payload.PSObject.Properties.Name -contains "status" -and $payload.status) {
        $status = [string]$payload.status
    }
}

$timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
$repoRoot = Split-Path -Parent $PSScriptRoot
$logDir = Join-Path $repoRoot ".github/hooks/logs"
$logFile = Join-Path $logDir "agent-logs.txt"

if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

switch ($Phase.ToLowerInvariant()) {
    "pre" {
        $line = "[$timestamp] Tool execution initiated: $toolName"
    }
    "post" {
        $line = "[$timestamp] Tool execution completed: $toolName with status: $status"
    }
    default {
        $line = "[$timestamp] Hook event: $Phase tool=$toolName"
    }
}

Add-Content -Path $logFile -Value $line -Encoding UTF8
exit 0
}
