#!/usr/bin/env bash

set -eux

NO_INSTALL=${NO_INSTALL:-0}

dotfiles_home=${HOME}/MyDotFiles
if [ ! -d ${dotfiles_home} ]; then
    git clone https://github.com/kmdkuk/MyDotFiles.git ${dotfiles_home}
else
    git -C ${dotfiles_home} pull origin master || true
fi

function add-link() {
    if [ -z $1 -a -z $2 ]; then
        : "invalid args 1: ${1}, 2: ${2}"
        exit 1
    fi
    ln -sf ${dotfiles_home}/${1} ${HOME}/${2}
}

: "prepare shimlink"
: "fish"
mkdir -p ${HOME}/.config/fish/functions
add-link fish/.config/fish/config.fish .config/fish/config.fish
mkdir -p ${HOME}/.config/fish/completions;
add-link .asdf/completions/asdf.fish .config/fish/completions
add-link fish/.config/fish/functions/ghq-cd.fish .config/fish/functions/ghq-cd.fish
add-link fish/.config/fish/functions/check-update-dotfiles.fish .config/fish/functions/check-update-dotfiles.fish

: "bash/zsh"
add-link .bashrc .bashrc
add-link .inputrc .inputrc
add-link .zshrc .zshrc

: "starship"
add-link starship.toml .config/starship.toml

: "vim"
add-link vim/.vimrc .vimrc

: "nvim"
mkdir -p ${HOME}/.config/nvim
add-link nvim/init.lua .config/nvim/init.lua
add-link nvim/lua .config/nvim/lua

: "git"
mkdir -p ${HOME}/.config/git
add-link git/.config/git/config .config/git/config
add-link git/.config/git/template .config/git/template
add-link git/.config/git/ignore .config/git/ignore
add-link git/.config/git/work.config .config/git/work.config
add-link git/.config/git/alias.config .config/git/alias.config

add-link .ghqlist .ghqlist

: "tmux"
mkdir -p ${HOME}/.tmux
add-link tmux/.tmux/iceberg.tmux.conf .tmux/iceberg.tmux.conf
add-link tmux/.tmux.conf .tmux.conf

: "asdf"
add-link asdf/.asdfrc .asdfrc
add-link asdf/.tool-versions .tool-versions

# each OS. support macOSOS or Linux
if [ "$(uname)" == 'Darwin' ]; then
    : "macOS"
    add-link .Brewfile .Brewfile
    add-link tmux/.tmux/osx.tmux.conf .tmux/local.tmux.conf
    add-link git/.config/git/osx.config .config/git/local.config
    # set defaults
    defaults write com.apple.finder CreateDesktop -boolean false
    killAll Finder
fi
if [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    : "Linux"
    add-link tmux/.tmux/linux.tmux.conf .tmux/local.tmux.conf
    add-link git/.config/git/linux.config .config/git/local.config
fi

: "bin"
mkdir -p ${HOME}/bin
bins="$(ls ${dotfiles_home}/bin)"
for b in ${bins[@]}; do
    add-link bin/$b bin/$b
done

: "install tools"
if [ ${NO_INSTALL} = "1" ]; then
    : "Skip install tools"
    exit 0
fi
${dotfiles_home}/bin/install-tools
