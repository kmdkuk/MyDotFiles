$ErrorActionPreference = "Stop"

$ScriptRoot = $PSScriptRoot
$ConfigPath = Join-Path $ScriptRoot "packages.json"

if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Warning "Scoop command is not found. Skipping."
    exit 0
}

if (!(Test-Path $ConfigPath)) {
    Write-Error "Configuration file not found at $ConfigPath"
    exit 1
}

Write-Output "Importing Scoop packages from $ConfigPath..."

# Import packages from JSON
scoop import $ConfigPath

Write-Output "Done."
