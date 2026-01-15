$ErrorActionPreference = "Stop"

$ScriptRoot = $PSScriptRoot

Write-Output "Starting package export..."
Write-Output "--------------------------------"

# Winget
$WingetScript = Join-Path $ScriptRoot "winget-export-packages.ps1"
if (Test-Path $WingetScript) {
    Write-Output "Running Winget export..."
    & $WingetScript
}
else {
    Write-Warning "winget-export-packages.ps1 not found."
}
Write-Output "--------------------------------"

# Chocolatey
$ChocoScript = Join-Path $ScriptRoot "choco-export-packages.ps1"
if (Test-Path $ChocoScript) {
    Write-Output "Running Chocolatey export..."
    & $ChocoScript
}
else {
    Write-Warning "choco-export-packages.ps1 not found."
}
Write-Output "--------------------------------"

# Scoop
$ScoopScript = Join-Path $ScriptRoot "scoop-export-packages.ps1"
if (Test-Path $ScoopScript) {
    Write-Output "Running Scoop export..."
    & $ScoopScript
}
else {
    Write-Warning "scoop-export-packages.ps1 not found."
}
Write-Output "--------------------------------"

Write-Output "All exports completed."
