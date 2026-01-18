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
add-link .config/fish/config.fish .config/fish/config.fish
mkdir -p ${HOME}/.config/fish/completions;
add-link home/completions/asdf.fish .config/fish/completions
add-link .config/fish/functions/ghq-cd.fish .config/fish/functions/ghq-cd.fish
add-link .config/fish/functions/check-update-dotfiles.fish .config/fish/functions/check-update-dotfiles.fish

: "bash/zsh"
add-link home/.bashrc .bashrc
add-link home/.inputrc .inputrc
add-link home/.zshrc .zshrc

: "starship"
add-link .config/starship.toml .config/starship.toml

: "erdtree"
add-link .config/erdtree.toml .config/erdtree.toml

: "gemini"
mkdir -p ${HOME}/.gemini
add-link .gemini/GEMINI.md .gemini/GEMINI.md
add-link .gemini/v5.md .gemini/v5.md
add-link .gemini/planning-mode-guard.md .gemini/planning-mode-guard.md
add-link .gemini/commit-message-format.md .gemini/commit-message-format.md
add-link .gemini/pr-message-format.md .gemini/pr-message-format.md

: "vim"
add-link home/.vimrc .vimrc

: "nvim"
mkdir -p ${HOME}/.config/nvim/lua
add-link .config/nvim/init.lua .config/nvim/init.lua
add-link .config/nvim/lua/lazy_nvim.lua .config/nvim/lua/lazy_nvim.lua
add-link .config/nvim/lua/plugins.lua .config/nvim/lua/plugins.lua

: "git"
mkdir -p ${HOME}/.config/git
add-link .config/git/config .config/git/config
add-link .config/git/template .config/git/template
add-link .config/git/ignore .config/git/ignore
add-link .config/git/work.config .config/git/work.config
add-link .config/git/alias.config .config/git/alias.config

add-link home/.ghqlist .ghqlist

: "tmux"
mkdir -p ${HOME}/.tmux
add-link home/.tmux/iceberg.tmux.conf .tmux/iceberg.tmux.conf
add-link home/.tmux.conf .tmux.conf

# each OS. support macOSOS or Linux
if [ "$(uname)" == 'Darwin' ]; then
    : "macOS"
    add-link home/.Brewfile .Brewfile
    add-link home/.tmux/osx.tmux.conf .tmux/local.tmux.conf
    add-link .config/git/osx.config .config/git/local.config
    # set defaults
    defaults write com.apple.finder CreateDesktop -boolean false
    killAll Finder
fi
if [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    : "Linux"
    add-link home/.tmux/linux.tmux.conf .tmux/local.tmux.conf
    add-link .config/git/linux.config .config/git/local.config
fi

: "aqua"
mkdir -p ${HOME}/.config/aquaproj-aqua
add-link .config/aquaproj-aqua/aqua.yaml .config/aquaproj-aqua/aqua.yaml

: "bin"
mkdir -p ${HOME}/bin
# bins="$(ls ${dotfiles_home}/bin)"
# for b in ${bins[@]}; do
#     add-link bin/$b bin/$b
# done
# Use globs instead of ls command substitution for safety
for b in ${dotfiles_home}/bin/*; do
    filename=$(basename "$b")
    # exclude install-tools
    if [ "$filename" == "install-tools" ]; then continue; fi
    add-link bin/$filename bin/$filename
done

: "install tools"
if [ ${NO_INSTALL} = "1" ]; then
    : "Skip install tools"
    exit 0
fi
${dotfiles_home}/bin/install-tools
