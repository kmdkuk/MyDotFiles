# MyDotFiles

[![daily](https://github.com/kmdkuk/MyDotFiles/actions/workflows/daily.yaml/badge.svg)](https://github.com/kmdkuk/MyDotFiles/actions/workflows/daily.yaml)

Linux

```bash
$ curl -sSLf setup.kmdk.uk | bash
# or
$ curl -sSLf setup.kmdk.uk/setup.sh | bash
```

Windows

```powershell
$ curl -sSLf setup.kmdk.uk/setup.ps1 | pwsh
```

## benchmark

```
# 通常計測（5回実行して平均を表示）
bash scripts/benchmark.sh
# 回数指定
bash scripts/benchmark.sh --count 10
# 詳細プロファイリング（ボトルネック解析）
bash scripts/benchmark.sh --profile
# -> profile.log の生成と解析結果を表示
```

2026/01/13
```
Analyzing profile log...
Total entries: 884
Total duration: 0.4139s
```

## ディレクトリ構成

このリポジトリは以下のルールでディレクトリを構成しています。

- **home**: ホームディレクトリ直下に配置される設定ファイル（dotfiles）。`setup.sh` 等で `$HOME` にシンボリックリンクが作成される設定ファイル群です（例: `.bashrc`, `.vimrc`）。
- **.config**: XDG Base Directory Specification に準拠した設定ファイル群（例: `nvim`, `fish`, `starship`）。`$HOME/.config` に展開されます。
- **bin**: 自作スクリプトやユーティリティツール。パスを通すことでコマンドとして更に使用できます。
- **shell**: シェル（Bash/Zsh）の共通設定、エイリアス、関数定義など分散管理されたシェルスクリプト群。
- **app**: アプリケーションごとの固有設定やインストール関連ファイル（例: `iterm2` のプロファイル, `autohotkey` のスクリプト）。
- **scripts**: このリポジトリ自体の管理やセットアップ、ベンチマークに使用するスクリプト。
- **windows**: Windows 環境固有の設定ファイル。
