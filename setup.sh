#!/bin/bash

mkdir -p $HOME/.config/nvim/
ln -s $HOME/MyDotFiles/.vimrc $HOME/.config/nvim/init.vim
mkdir -p $HOME/.config/fish/functions
ln -s $HOME/MyDotFiles/.config/fish/config.fish $HOME/.config/fish/config.fish
ln -s $HOME/MyDotFiles/.config/fish/functions/ghq-cd.fish $HOME/.config/fish/functions/ghq-cd.fish

DOT_FILES=(Brewfile .vimrc .tmux.conf .commit_template .gitconfig .gitignore_global .rubocop.yml .gdbinit .tmux)

for file in ${DOT_FILES[@]}
do
    ln -s $HOME/MyDotFiles/$file $HOME/$file
done

