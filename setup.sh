#!/bin/bash

mkdir -p $HOME/.config/nvim/
ln -s $HOME/MyDotFiles/.vimrc $HOME/.config/nvim/init.vim

DOT_FILES=(.zshrc .Brewfile .github.zshrc .vimrc .tmux.conf .commit_template .gitconfig .gitignore_global .latexmkrc .zpreztorc .rubocop.yml .p10k.zsh .gdbinit)

for file in ${DOT_FILES[@]}
do
    ln -s $HOME/MyDotFiles/$file $HOME/$file
done

