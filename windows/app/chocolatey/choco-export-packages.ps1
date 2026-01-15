$ErrorActionPreference = "Stop"

$ScriptRoot = $PSScriptRoot
$ConfigPath = Join-Path $ScriptRoot "packages.config"



if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Warning "Chocolatey command is not found. Skipping."
    exit 0
}

Write-Output "Exporting Chocolatey packages to $ConfigPath..."

# Export packages to XML
# limitedOutput enforces a consistent format if we were parsing, but for export command standard is fine.
# choco export output to file
choco export $ConfigPath

# Sort lines in packages.config to ensure deterministic output
if (Test-Path $ConfigPath) {
    Write-Output "Sorting packages by id..."
    [xml]$xml = Get-Content $ConfigPath -Encoding UTF8
    $packages = $xml.packages.package | Sort-Object id
    
    # Reconstruct XML to ensure order
    $newXml = [xml]"<?xml version=`"1.0`" encoding=`"utf-8`"?><packages></packages>"
    foreach ($pkg in $packages) {
        $importNode = $newXml.ImportNode($pkg, $true)
        $newXml.DocumentElement.AppendChild($importNode) | Out-Null
    }
    
    # Save with clean formatting
    $settings = New-Object System.Xml.XmlWriterSettings
    $settings.Indent = $true
    $settings.IndentChars = "  "
    $settings.Encoding = [System.Text.Encoding]::UTF8

    $writer = [System.Xml.XmlWriter]::Create($ConfigPath, $settings)
    $newXml.Save($writer)
    $writer.Close()
}

# Remove backup file if exists
$BackupPath = "${ConfigPath}.backup"
if (Test-Path $BackupPath) {
    Remove-Item $BackupPath -Force
}

Write-Output "Done. Generated $ConfigPath"
