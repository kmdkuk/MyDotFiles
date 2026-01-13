$ErrorActionPreference = "Stop"

$ScriptRoot = $PSScriptRoot
$RepoRoot = Split-Path -Parent $ScriptRoot
$ConfigPath = Join-Path $RepoRoot "app\winget\packages.json"

if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "Winget command is not found. Please update App Installer from Microsoft Store."
    exit 1
}

if (!(Test-Path $ConfigPath)) {
    Write-Error "Configuration file not found at $ConfigPath"
    exit 1
}

Write-Output "Importing Winget packages from $ConfigPath..."
winget import -i $ConfigPath --accept-package-agreements --accept-source-agreements

Write-Output "Done."
