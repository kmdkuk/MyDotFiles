$ErrorActionPreference = "Stop"

$ScriptRoot = $PSScriptRoot
$ConfigPath = Join-Path $ScriptRoot "packages.json"



if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "Winget command is not found. Please update App Installer from Microsoft Store."
    exit 1
}

Write-Output "Exporting Winget packages to $ConfigPath..."

# Export packages to JSON
# --accept-source-agreements is important for automation
winget export -o $ConfigPath --source winget --accept-source-agreements

if (Test-Path $ConfigPath) {
    Write-Output "Sorting packages by PackageIdentifier..."
    $json = Get-Content $ConfigPath | ConvertFrom-Json
    foreach ($source in $json.Sources) {
        $source.Packages = $source.Packages | Sort-Object PackageIdentifier
    }
    $json | ConvertTo-Json -Depth 10 | Set-Content $ConfigPath -Encoding UTF8
}

Write-Output "Done. Generated $ConfigPath"
