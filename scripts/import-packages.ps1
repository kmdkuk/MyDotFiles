$ErrorActionPreference = "Stop"

$ScriptRoot = $PSScriptRoot

Write-Output "Starting package import..."
Write-Output "--------------------------------"

# Winget
$WingetScript = Join-Path $ScriptRoot "winget-import-packages.ps1"
if (Test-Path $WingetScript) {
    Write-Output "Running Winget import..."
    & $WingetScript
}
else {
    Write-Warning "winget-import-packages.ps1 not found."
}
Write-Output "--------------------------------"

# Chocolatey
$ChocoScript = Join-Path $ScriptRoot "choco-import-packages.ps1"
if (Test-Path $ChocoScript) {
    Write-Output "Running Chocolatey import..."
    & $ChocoScript
}
else {
    Write-Warning "choco-import-packages.ps1 not found."
}
Write-Output "--------------------------------"

# Scoop
$ScoopScript = Join-Path $ScriptRoot "scoop-import-packages.ps1"
if (Test-Path $ScoopScript) {
    Write-Output "Running Scoop import..."
    & $ScoopScript
}
else {
    Write-Warning "scoop-import-packages.ps1 not found."
}
Write-Output "--------------------------------"

Write-Output "All imports completed."
