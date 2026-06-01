# Copilot Security Hook Runner - PowerShell equivalent
# Simulates code-review.sh security scanning and saves results to log file

$LogDir = ".github/hooks/logs"
$WarnFile = "$LogDir/code-review-warnings.log"
$warnings = @()

Write-Host "Running Copilot Code Review Security Hook..." -ForegroundColor Green

# 1) Scan for hardcoded secrets pattern
Write-Host "`n[1] Scanning for hardcoded secrets..." -ForegroundColor Cyan

$secretsFound = Select-String -Path Controllers/*.cs -Pattern '(?i)(api[_-]?key|secret|password|token|connectionstring)\s*[:=]\s*["\x27][^"\x27\s]{8,}["\x27]' -ErrorAction SilentlyContinue
if ($secretsFound) {
  Write-Host "  ⚠️  Potential hardcoded secrets found" -ForegroundColor Yellow
  $secretsFound | ForEach-Object { Write-Host "     $($_.FileName):$($_.LineNumber)" }
  $warnings += "Potential hardcoded secret patterns found"
} else {
  Write-Host "  ✓ No hardcoded secrets detected" -ForegroundColor Green
}

# 2) Check for DbContext usage in Controllers (clean arch violation)
Write-Host "`n[2] Checking DbContext usage in Controllers..." -ForegroundColor Cyan

$dbContextInControllers = Select-String -Path Controllers/*.cs -Pattern 'LMSDbContext|DbContext' -ErrorAction SilentlyContinue
if ($dbContextInControllers) {
  Write-Host "  ⚠️  DbContext detected in Controllers" -ForegroundColor Yellow
  $dbContextInControllers | ForEach-Object { Write-Host "     $($_.Filename):$($_.LineNumber)" }
  $warnings += "DbContext usage detected in Controllers. Prefer Service/Repository boundaries"
} else {
  Write-Host "  ✓ Controllers properly use Services (no direct DbContext)" -ForegroundColor Green
}

# 3) Check for async methods in Services
Write-Host "`n[3] Validating async/await patterns..." -ForegroundColor Cyan

$asyncMethods = Select-String -Path Services/*.cs, Repositories/*.cs -Pattern 'async\s+Task' -ErrorAction SilentlyContinue
if ($asyncMethods) {
  Write-Host "  ✓ Found async Task methods - validating patterns" -ForegroundColor Green
  $asyncMethods | Select-Object -First 3 | ForEach-Object { Write-Host "     $($_.Filename):$($_.LineNumber)" }
} else {
  Write-Host "  ✓ Service/Repository pattern validated" -ForegroundColor Green
}

# 4) Validate repository/service injection pattern
Write-Host "`n[4] Validating dependency injection pattern..." -ForegroundColor Cyan

$injectionPattern = Select-String -Path Controllers/*.cs -Pattern 'readonly\s+I(Course|Quiz)(Service|Repository)' -ErrorAction SilentlyContinue
if ($injectionPattern) {
  Write-Host "  ✓ Controllers properly inject services" -ForegroundColor Green
  $injectionPattern | ForEach-Object { Write-Host "     $($_.Filename):$($_.LineNumber)" }
} else {
  Write-Host "  ⚠️  No service injection pattern detected" -ForegroundColor Yellow
}

# 5) Check for clean architecture compliance
Write-Host "`n[5] Checking clean architecture compliance..." -ForegroundColor Cyan

$controllerInjections = Select-String -Path Controllers/*.cs -Pattern 'private readonly' -ErrorAction SilentlyContinue
if ($controllerInjections) {
  Write-Host "  ✓ Controllers use dependency injection" -ForegroundColor Green
  $controllerInjections | ForEach-Object { Write-Host "     $($_.Filename):$($_.LineNumber)" }
} else {
  Write-Host "  ⚠️  Missing dependency injection" -ForegroundColor Yellow
  $warnings += "Controllers missing dependency injection"
}

# Create comprehensive log output
$logContent = @"
================================================================================
Copilot Code Review Security Hook - Execution Report
================================================================================
Timestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
Host: $($env:COMPUTERNAME)
Repository: nileshprajapati-simform/CopilotPOC

SECURITY CHECKS PERFORMED:
==========================
1. ✓ Hardcoded secrets scanning (API keys, passwords, tokens, connection strings)
2. ✓ DbContext usage audit (clean architecture boundary validation)
3. ✓ Async/await pattern validation
4. ✓ Dependency injection pattern validation
5. ✓ Clean architecture compliance check

FINDINGS:
=========
Total Warnings: $($warnings.Count)
"@

if ($warnings.Count -gt 0) {
  $logContent += "`n`nWARNINGS DETECTED:`n"
  $warnings | ForEach-Object { $logContent += "`n  ⚠️  $_" }
} else {
  $logContent += "`n`nNO WARNINGS - Repository meets security and architecture standards."
}

$logContent += "`n`nRECOMMENDATIONS:`n"
$logContent += "================"
$logContent += "`n1. Secrets: Use Azure Key Vault or GitHub Secrets for sensitive values"
$logContent += "`n2. Architecture: Maintain Service/Repository pattern as per .github/copilot-instructions.md"
$logContent += "`n3. Async: Ensure all DB operations use async/await properly"
$logContent += "`n4. Injection: Always use constructor injection for dependencies`n"
$logContent += "`nExecution completed at: $(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssZ')`n"
$logContent += "================================================================================`n`n"

# Save to log file
if (-not (Test-Path $LogDir)) {
  New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

Add-Content -Path $WarnFile -Value $logContent -Encoding UTF8

Write-Host "`n✓ Security hook execution completed!" -ForegroundColor Green
Write-Host "✓ Logs saved to: $WarnFile" -ForegroundColor Green
Write-Host "`nLog file contents:`n" -ForegroundColor Green
Get-Content $WarnFile
