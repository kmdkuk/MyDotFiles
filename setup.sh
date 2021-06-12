#!/usr/bin/env bash

echo "ファイルのシンボリックリンクを準備"
echo "汎用ファイルを配置"
# fish
echo "fish"
mkdir -p $HOME/.config/fish/functions
ln -sf $HOME/MyDotFiles/fish/.config/fish/config.fish $HOME/.config/fish/config.fish
mkdir -p ~/.config/fish/completions;
ln -sf ~/.asdf/completions/asdf.fish ~/.config/fish/completions
ln -sf $HOME/MyDotFiles/fish/.config/fish/functions/ghq-cd.fish $HOME/.config/fish/functions/ghq-cd.fish
ln -sf $HOME/MyDotFiles/fish/.config/fish/functions/check-update-dotfiles.fish $HOME/.config/fish/functions/check-update-dotfiles.fish

# zsh/bash
ln -sf $HOME/MyDotFiles/.bashrc $HOME/.bashrc
ln -sf $HOME/MyDotFiles/.zshrc $HOME/.zshrc

# starship
echo "starship"
ln -sf $HOME/MyDotFiles/starship.toml $HOME/.config/starship.toml

# vim
echo "vim"
ln -sf $HOME/MyDotFiles/vim/.vimrc $HOME/.vimrc

# git
echo "git"
mkdir -p $HOME/.config/git
ln -sf $HOME/MyDotFiles/git/.config/git/config $HOME/.config/git/config
ln -sf $HOME/MyDotFiles/git/.config/git/template $HOME/.config/git/template
ln -sf $HOME/MyDotFiles/git/.config/git/ignore $HOME/.config/git/ignore
ln -sf $HOME/MyDotFiles/git/.config/git/work.config $HOME/.config/git/work.config

# tmux
echo "tmux"
mkdir -p $HOME/.tmux
ln -sf $HOME/MyDotFiles/tmux/.tmux/iceberg.tmux.conf $HOME/.tmux/iceberg.tmux.conf
ln -sf $HOME/MyDotFiles/tmux/.tmux.conf $HOME/.tmux.conf

echo "asdf"
ln -sf $HOME/MyDotFiles/asdf/.asdfrc $HOME/.asdfrc
ln -sf $HOME/MyDotFiles/asdf/.tool-versions $HOME/.tool-versions

# OSごとの分岐
if [ "$(uname)" == 'Darwin' ]; then
    # Mac
    echo "Mac用のファイルを配置"
    # brew
    ln -sf $HOME/MyDotFiles/Brewfile $HOME/Brewfile
    if [ -z "$(command -v brew)" ]; then
        echo "--- Install Homebrew is Start! ---"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew bundle
        echo "--- Install Homebrew is Done!  ---"
    fi
    # tmux
    ln -sf $HOME/MyDotFiles/tmux/.tmux/osx.tmux.conf $HOME/.tmux/local.tmux.conf
    # git
    ln -sf $HOME/MyDotFiles/git/.config/git/osx.config $HOME/.config/git/local.config
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    # Linux
    echo "Linux用のファイルを配置"
    ln -sf $HOME/MyDotFiles/tmux/.tmux/linux.tmux.conf $HOME/.tmux/local.tmux.conf
    # git
    ln -sf $HOME/MyDotFiles/git/.config/git/linux.config $HOME/.config/git/local.config
fi

