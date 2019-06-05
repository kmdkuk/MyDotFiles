#! /bin/zsh

# ホームディレクトリ
cd ~/
# tarファイルをダウンロード
sudo wget "https://github.com/peco/peco/releases/download/v0.5.3/peco_linux_386.tar.gz"
# 解凍
sudo tar xzvf peco_linux_386.tar.gz
cd peco_linux_386
# 実行権限変更
sudo chmod +x peco
# PATHの通っている所にpecoを配置
sudo cp peco /usr/local/bin
# バージョン確認
peco --version

go get github.com/motemen/ghq
go get github.com/github/hub
