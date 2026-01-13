$ErrorActionPreference = "Stop"

$ScriptRoot = $PSScriptRoot
$RepoRoot = Split-Path -Parent $ScriptRoot
$WingetDir = Join-Path $RepoRoot "app\winget"
$ConfigPath = Join-Path $WingetDir "packages.json"

if (!(Test-Path $WingetDir)) {
    New-Item -ItemType Directory -Path $WingetDir -Force | Out-Null
}

if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "Winget command is not found. Please update App Installer from Microsoft Store."
    exit 1
}

Write-Output "Exporting Winget packages to $ConfigPath..."

# Export packages to JSON
# --accept-source-agreements is important for automation
winget export -o $ConfigPath --source winget --accept-source-agreements

Write-Output "Done. Generated $ConfigPath"
