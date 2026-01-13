$ErrorActionPreference = "Stop"

# リポジトリのルートディレクトリを取得
$ScriptRoot = $PSScriptRoot
$RepoRoot = Split-Path -Parent $ScriptRoot
$ConfigPath = Join-Path $RepoRoot "app\chocolatey\packages.config"
$ChocoLibPath = "C:\ProgramData\chocolatey\lib"

# chocoコマンドの存在確認
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Error "Chocolatey (choco) がインストールされていません。"
    exit 1
}

Write-Output "Generating packages.config from installed Chocolatey packages (excluding dependencies)..."
Write-Output "Output Path: $ConfigPath"

# 1. インストール済みパッケージを取得
# -lo: Local only, -r: LimitOutput (machine readable), -y: Confirm yes
$chocoOutput = choco list -lo -r -y
$packages = @()
foreach ($line in $chocoOutput) {
    if ($line -match "^(.*?)\|") {
        $packages += $matches[1]
    }
}

Write-Output "Found $($packages.Count) packages."

# 2. 依存関係を収集
$dependencies = @{}

foreach ($pkgId in $packages) {
    # .nuspec ファイルを探す
    # フォルダ名は通常パッケージIDと一致するが、異なる場合も考慮して検索する
    $packageDir = Join-Path $ChocoLibPath $pkgId
    $nuspecPath = Join-Path $packageDir "$pkgId.nuspec"
    
    # nuspecが見つからない場合はフォルダ検索を試みる（バージョン付きフォルダ対策など）
    if (!(Test-Path $nuspecPath)) {
        # パッケージIDを含むフォルダを探す（完全一致優先、なければ前方一致）
        $candidateDir = Get-ChildItem -Path $ChocoLibPath -Directory | Where-Object { $_.Name -eq $pkgId } | Select-Object -First 1
        if (!$candidateDir) {
            $candidateDir = Get-ChildItem -Path $ChocoLibPath -Directory | Where-Object { $_.Name -like "$pkgId.*" } | Sort-Object Name -Descending | Select-Object -First 1
        }
        
        if ($candidateDir) {
            $candidateNuspec = Get-ChildItem -Path $candidateDir.FullName -Filter "*.nuspec" | Select-Object -First 1
            if ($candidateNuspec) {
                $nuspecPath = $candidateNuspec.FullName
            }
        }
    }

    if (Test-Path $nuspecPath) {
        try {
            [xml]$nuspecXml = Get-Content $nuspecPath
            # 名前空間がある場合とない場合のマッチング
            $deps = $nuspecXml.package.metadata.dependencies.dependency
            if ($deps) {
                foreach ($dep in $deps) {
                    if ($dep.id) {
                        $dependencies[$dep.id.ToLower()] = $true
                    }
                }
            }
            # グループ化された依存関係 (<group>タグ内) の対応
            $groups = $nuspecXml.package.metadata.dependencies.group
            if ($groups) {
                foreach ($group in $groups) {
                    $groupDeps = $group.dependency
                    if ($groupDeps) {
                        foreach ($dep in $groupDeps) {
                            if ($dep.id) {
                                $dependencies[$dep.id.ToLower()] = $true
                            }
                        }
                    }
                }
            }

        }
        catch {
            Write-Warning "Failed to parse nuspec for $pkgId at $nuspecPath"
        }
    }
    else {
        Write-Warning "Nuspec not found for $pkgId"
    }
}

Write-Output "Found $($dependencies.Count) unique dependency packages."

# 3. XML生成
$xmlSettings = New-Object System.Xml.XmlWriterSettings
$xmlSettings.Indent = $true
$xmlSettings.IndentChars = "  "
$xmlSettings.NewLineOnAttributes = $false
$xmlSettings.Encoding = [System.Text.Encoding]::UTF8

$ms = New-Object System.IO.MemoryStream
$writer = [System.Xml.XmlWriter]::Create($ms, $xmlSettings)

$writer.WriteStartDocument()
$writer.WriteStartElement("packages")

$excludedCount = 0
$includedCount = 0

foreach ($pkgId in $packages) {
    if ($dependencies.ContainsKey($pkgId.ToLower())) {
        $excludedCount++
        continue
    }
    
    $writer.WriteStartElement("package")
    $writer.WriteAttributeString("id", $pkgId)
    # バージョンは記載しない
    $writer.WriteEndElement()
    $includedCount++
}

$writer.WriteEndElement() # packages
$writer.WriteEndDocument()
$writer.Flush()
$writer.Dispose()

# ファイルに保存
[System.IO.File]::WriteAllBytes($ConfigPath, $ms.ToArray())
$ms.Dispose()

Write-Output "Generated packages.config with $includedCount packages (excluded $excludedCount dependencies)."

# Backupファイルがあれば削除 (git管理されているため不要)
$BackupPath = "$ConfigPath.backup"
if (Test-Path $BackupPath) {
    Remove-Item -Path $BackupPath -Force
    Write-Output "Removed backup file: $BackupPath"
}
