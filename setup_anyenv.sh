#! /bin/zsh
git clone https://github.com/riywo/anyenv ~/.anyenv

source ~/.zshrc

anyenv install --init

anyenv install goenv
anyenv install rbenv
anyenv install nodenv

source ~/.zshrc

sudo apt install -y ruby-build

rbenv install 2.6.3
rbenv global 2.6.3

goenv install 1.12.1
goenv global 1.12.1

nodenv install 12.4.0
nodenv global 12.4.0
