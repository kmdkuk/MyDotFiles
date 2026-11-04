$ErrorActionPreference = "Stop"

$ScriptRoot = $PSScriptRoot
$ConfigPath = Join-Path $ScriptRoot "packages.json"

if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "Winget command is not found. Please update App Installer from Microsoft Store."
    exit 1
}

Write-Output "Exporting Winget packages to $ConfigPath..."

# Export both the winget source (regular packages) and msstore (Microsoft Store
# apps) so Store-only installs are captured too, then merge into one file.
# --accept-source-agreements is important for automation
$Sources = @()
foreach ($SourceName in @("winget", "msstore")) {
    $TempPath = Join-Path $ScriptRoot "packages.$SourceName.tmp.json"
    winget export -o $TempPath --source $SourceName --accept-source-agreements
    if (Test-Path $TempPath) {
        $SourceJson = Get-Content $TempPath -Encoding UTF8 | ConvertFrom-Json
        $Sources += $SourceJson.Sources
        Remove-Item $TempPath
    }
}

# Some installed packages are correctly resolved by `winget list`/`install`
# (via ARP correlation) but are not returned by `winget export` itself, due to
# ambiguous/ stale source-index matching. Keep an explicit allowlist here so
# `winget import` still reinstalls them on a fresh machine.
$ExtraWingetPackageIds = @(
    "Devolutions.UniGetUI" # not picked up by `winget export`; confirmed via `winget list --id`
)

Write-Output "Sorting packages by PackageIdentifier..."
foreach ($source in $Sources) {
    if ($source.SourceDetails.Name -eq "winget") {
        $ExistingIds = $source.Packages | ForEach-Object { $_.PackageIdentifier }
        foreach ($ExtraId in $ExtraWingetPackageIds) {
            if ($ExistingIds -notcontains $ExtraId) {
                $source.Packages += [pscustomobject]@{ PackageIdentifier = $ExtraId }
            }
        }
    }
    $source.Packages = @($source.Packages | Sort-Object PackageIdentifier)
}

$Merged = [ordered]@{
    "`$schema"     = "https://aka.ms/winget-packages.schema.2.0.json"
    CreationDate   = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.ffK")
    Sources        = $Sources
    WinGetVersion  = (winget --version).TrimStart("v")
}
$Merged | ConvertTo-Json -Depth 10 | Set-Content $ConfigPath -Encoding UTF8

Write-Output "Done. Generated $ConfigPath"
