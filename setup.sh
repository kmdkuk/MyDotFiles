#!/bin/bash

DOT_FILES=( .zshrc .vimrc .tmux.conf)

for file in ${DOT_FILES[@]}
do
    ln -s $HOME/MyDotFiles/$file $HOME/$file
done

