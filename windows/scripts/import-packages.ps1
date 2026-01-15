$ErrorActionPreference = "Stop"

$ScriptRoot = $PSScriptRoot

Write-Output "Starting package import..."
Write-Output "--------------------------------"

# Winget
$WingetScript = Join-Path $ScriptRoot "..\app\winget\winget-import-packages.ps1"
if (Test-Path $WingetScript) {
    Write-Output "Running Winget import..."
    & $WingetScript
}
else {
    Write-Warning "winget-import-packages.ps1 not found at $WingetScript"
}
Write-Output "--------------------------------"

# Chocolatey
$ChocoScript = Join-Path $ScriptRoot "..\app\chocolatey\choco-import-packages.ps1"
if (Test-Path $ChocoScript) {
    Write-Output "Running Chocolatey import..."
    & $ChocoScript
}
else {
    Write-Warning "choco-import-packages.ps1 not found at $ChocoScript"
}
Write-Output "--------------------------------"

# Scoop
$ScoopScript = Join-Path $ScriptRoot "..\app\scoop\scoop-import-packages.ps1"
if (Test-Path $ScoopScript) {
    Write-Output "Running Scoop import..."
    & $ScoopScript
}
else {
    Write-Warning "scoop-import-packages.ps1 not found at $ScoopScript"
}
Write-Output "--------------------------------"

Write-Output "All imports completed."
