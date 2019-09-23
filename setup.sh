#!/bin/bash

DOT_FILES=( .github.zshrc .vimrc .tmux.conf .commit_template .gitconfig .gitignore_global .latexmkrc .zpreztorc .rubocop.yml .p10k.zsh)

for file in ${DOT_FILES[@]}
do
    ln -s $HOME/MyDotFiles/$file $HOME/$file
done

