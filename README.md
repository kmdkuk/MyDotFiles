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

## Other tools

- gh
    - linux
      https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian-ubuntu-linux-raspberry-pi-os-apt
