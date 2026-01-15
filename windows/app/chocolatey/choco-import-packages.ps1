$ErrorActionPreference = "Stop"

$ScriptRoot = $PSScriptRoot
$ConfigPath = Join-Path $ScriptRoot "packages.config"

if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Warning "Chocolatey command is not found. Skipping."
    exit 0
}

if (!(Test-Path $ConfigPath)) {
    Write-Error "Configuration file not found at $ConfigPath"
    exit 1
}

Write-Output "Importing Chocolatey packages from $ConfigPath..."

# Import packages from XML
# -y to confirm all prompts
choco install $ConfigPath -y

Write-Output "Done."
