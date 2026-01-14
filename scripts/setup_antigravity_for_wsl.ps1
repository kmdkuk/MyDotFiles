# エラーが発生したら即座に停止
$ErrorActionPreference = "Stop"

Write-Host "=== Antigravity Setup for WSL Support (Safe Copy) Start ==="

# --- パス定義 ---
$AntigravityBase = "$env:LOCALAPPDATA\Programs\Antigravity"
$AntigravityBin = "$AntigravityBase\bin\antigravity"
$VscodeExtDir = "$env:USERPROFILE\.vscode\extensions"
$AntigravityExtDest = "$AntigravityBase\resources\app\extensions\antigravity-remote-wsl"

# --- Check 1: Antigravityの存在確認 ---
Write-Host "Checking Antigravity installation..."
if (-not (Test-Path $AntigravityBin)) {
    Write-Error "ERROR: Antigravity binary not found at $AntigravityBin"
    Write-Host "Please install Google Antigravity." -ForegroundColor Red
    exit 1
}
Write-Host " -> OK: Antigravity found." -ForegroundColor Gray

# --- Check 2: VS Code (拡張機能フォルダ) の存在確認 ---
Write-Host "Checking VS Code extensions directory..."
if (-not (Test-Path $VscodeExtDir)) {
    Write-Error "ERROR: VS Code extensions directory not found at $VscodeExtDir"
    Write-Host "Please install VS Code." -ForegroundColor Red
    exit 1
}
Write-Host " -> OK: VS Code extensions directory found." -ForegroundColor Gray

# --- Check 3: WSL拡張機能とスクリプトの存在確認 (バージョン比較対応) ---
Write-Host "Checking for VS Code Remote-WSL extension scripts..."

# 正規表現でバージョン番号を抽出して検索
$wslExtensions = Get-ChildItem -Path $VscodeExtDir | 
Where-Object { $_.Name -match "^ms-vscode-remote\.remote-wsl-(\d+\.\d+\.\d+)" }

if (-not $wslExtensions) {
    Write-Error "ERROR: 'Remote - WSL' extension not found in VS Code."
    Write-Host "Please install the 'WSL' extension (ms-vscode-remote.remote-wsl) in VS Code." -ForegroundColor Red
    exit 1
}

# バージョン番号で降順ソートして最新を取得
$latestWslExt = $wslExtensions | 
Sort-Object { [Version]($_.Name -replace "^ms-vscode-remote\.remote-wsl-", "") } -Descending | 
Select-Object -First 1

Write-Host " -> Selected Extension Version: $($latestWslExt.Name)" -ForegroundColor Cyan

$sourceScripts = Join-Path $latestWslExt.FullName "scripts"

if (-not (Test-Path $sourceScripts)) {
    Write-Error "ERROR: 'scripts' folder not found inside the extension."
    Write-Host "Target extension: $($latestWslExt.Name)" -ForegroundColor Red
    exit 1
}
Write-Host " -> OK: Found scripts folder." -ForegroundColor Gray


# ========================================================
# メイン処理
# ========================================================

# --- 手順1: 起動スクリプトの編集 & 改行コード修正 (CRLF -> LF) ---
Write-Host "`n[Step 1] Editing startup script and fixing line endings..."

try {
    # 生のテキストとして読み込む
    $content = [IO.File]::ReadAllText($AntigravityBin)
    
    # ターゲット文字列
    $targetStr = 'WSL_EXT_ID="ms-vscode-remote.remote-wsl"'
    $newStr = 'WSL_EXT_ID="google.antigravity-remote-wsl"'
    
    # 1. IDの書き換え判定
    if ($content.Contains($targetStr)) {
        $content = $content.Replace($targetStr, $newStr)
        Write-Host " -> Updated Extension ID." -ForegroundColor Green
    }
    elseif ($content.Contains($newStr)) {
        Write-Host " -> Extension ID already updated." -ForegroundColor Yellow
    }
    else {
        Write-Warning "Target ID string not found. File structure might have changed."
    }

    # 2. 改行コードの強制 LF 化
    if ($content -match "`r`n") {
        $content = $content.Replace("`r`n", "`n")
        Write-Host " -> Converted CRLF to LF (Unix style)." -ForegroundColor Green
    }

    # 3. 保存 (UTF-8 BOMなし)
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [IO.File]::WriteAllText($AntigravityBin, $content, $utf8NoBom)
    
}
catch {
    Write-Error "Failed to process the startup script."
    Write-Error $_
    exit 1
}

# --- 手順2: ヘルパースクリプトのコピー (安全なコピー) ---
Write-Host "`n[Step 2] Copying helper scripts..."

try {
    # 宛先フォルダがなければ作成 (あれば何もしない)
    if (-not (Test-Path $AntigravityExtDest)) {
        New-Item -ItemType Directory -Path $AntigravityExtDest -Force | Out-Null
        Write-Host " -> Created destination directory."
    }
    
    # 既存のファイルを削除せず、上書きコピー
    Copy-Item -Path $sourceScripts -Destination $AntigravityExtDest -Recurse -Force
    
    Write-Host " -> Scripts copied to: $AntigravityExtDest" -ForegroundColor Green
}
catch {
    Write-Error "Failed to copy scripts."
    Write-Error $_
    exit 1
}

Write-Host "`n=== Setup Completed Successfully ==="
