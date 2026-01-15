$ErrorActionPreference = "Stop"

$ScriptRoot = $PSScriptRoot
$ConfigPath = Join-Path $ScriptRoot "packages.json"



if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Warning "Scoop command is not found. Skipping."
    exit 0
}

Write-Output "Exporting Scoop packages to $ConfigPath..."

# Export packages to JSON
# scoop export > file
scoop export | Out-File -FilePath $ConfigPath -Encoding UTF8

if (Test-Path $ConfigPath) {
    Write-Output "Sorting packages by Name..."
    $json = Get-Content $ConfigPath -Encoding UTF8 | ConvertFrom-Json
    if ($json.apps) {
        $json.apps = $json.apps | Sort-Object Name
        $json | ConvertTo-Json -Depth 10 | Set-Content $ConfigPath -Encoding UTF8
    }
}

Write-Output "Done. Generated $ConfigPath"
