#!/usr/bin/env bash

set -eux

NO_INSTALL=${NO_INSTALL:-0}

dotfiles_home=${HOME}/MyDotFiles
if [ ! -d ${dotfiles_home} ]; then
    git clone https://github.com/kmdkuk/MyDotFiles.git ${dotfiles_home}
else
    git -C ${dotfiles_home} pull origin master || true
fi

: "prepare shimlink"
: "fish"
mkdir -p ${HOME}/.config/fish/functions
ln -sf ${dotfiles_home}/fish/.config/fish/config.fish ${HOME}/.config/fish/config.fish
mkdir -p ${HOME}/.config/fish/completions;
ln -sf ${HOME}/.asdf/completions/asdf.fish ${HOME}/.config/fish/completions
ln -sf ${dotfiles_home}/fish/.config/fish/functions/ghq-cd.fish ${HOME}/.config/fish/functions/ghq-cd.fish
ln -sf ${dotfiles_home}/fish/.config/fish/functions/check-update-dotfiles.fish ${HOME}/.config/fish/functions/check-update-dotfiles.fish

: "bash/zsh"
ln -sf ${dotfiles_home}/.bashrc ${HOME}/.bashrc
ln -sf ${dotfiles_home}/.zshrc ${HOME}/.zshrc

: "starship"
ln -sf ${dotfiles_home}/starship.toml ${HOME}/.config/starship.toml

: "vim"
ln -sf ${dotfiles_home}/vim/.vimrc ${HOME}/.vimrc

: "git"
mkdir -p ${HOME}/.config/git
ln -sf ${dotfiles_home}/git/.config/git/config ${HOME}/.config/git/config
ln -sf ${dotfiles_home}/git/.config/git/template ${HOME}/.config/git/template
ln -sf ${dotfiles_home}/git/.config/git/ignore ${HOME}/.config/git/ignore
ln -sf ${dotfiles_home}/git/.config/git/work.config ${HOME}/.config/git/work.config

ln -sf ${dotfiles_home}/.ghqlist ${HOME}/.ghqlist

: "tmux"
mkdir -p ${HOME}/.tmux
ln -sf ${dotfiles_home}/tmux/.tmux/iceberg.tmux.conf ${HOME}/.tmux/iceberg.tmux.conf
ln -sf ${dotfiles_home}/tmux/.tmux.conf ${HOME}/.tmux.conf

: "asdf"
ln -sf ${dotfiles_home}/asdf/.asdfrc ${HOME}/.asdfrc
ln -sf ${dotfiles_home}/asdf/.tool-versions ${HOME}/.tool-versions

# each OS. support macOSOS or Linux
if [ "$(uname)" == 'Darwin' ]; then
    : "macOS"
    ln -sf ${dotfiles_home}/.Brewfile ${HOME}/.Brewfile
    ln -sf ${dotfiles_home}/tmux/.tmux/osx.tmux.conf ${HOME}/.tmux/local.tmux.conf
    ln -sf ${dotfiles_home}/git/.config/git/osx.config ${HOME}/.config/git/local.config

    # set defaults
    defaults write com.apple.finder CreateDesktop -boolean false
    killAll Finder
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    : "Linux"
    ln -sf ${dotfiles_home}/tmux/.tmux/linux.tmux.conf ${HOME}/.tmux/local.tmux.conf
    ln -sf ${dotfiles_home}/git/.config/git/linux.config ${HOME}/.config/git/local.config
    /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash /usr/local/etc/bash_completion.d/git-completion.bash
fi

: "bin"
mkdir -p ${HOME}/bin
bins="$(ls ${dotfiles_home}/bin)"
for b in ${bins[@]}; do
    ln -sf ${dotfiles_home}/bin/$b ${HOME}/bin/$b
done

source ${HOME}/.bashrc

: "install tools"
if [ ${NO_INSTALL} = "1" ]; then
    : "Skip install tools"
    exit 0
fi
${dotfiles_home}/bin/install-tools
