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
    '{"permissionDecision":"allow"}'
    exit 0
}

$buildLog = Join-Path $env:TEMP "copilot-pr-validation-build.log"
$testLog = Join-Path $env:TEMP "copilot-pr-validation-test.log"

$null = & dotnet build LMSWebAPI.sln --nologo *> $buildLog
if ($LASTEXITCODE -ne 0) {
    '{"permissionDecision":"deny","permissionDecisionReason":"Blocked by PR validation: dotnet build failed. Fix compile errors before editing files."}'
    exit 0
}

$null = & dotnet test LMSWebAPI.sln --nologo --no-build *> $testLog
if ($LASTEXITCODE -ne 0) {
    '{"permissionDecision":"deny","permissionDecisionReason":"Blocked by PR validation: dotnet test failed. Fix failing tests before editing files."}'
    exit 0
}

'{"permissionDecision":"allow"}'
exit 0
}
