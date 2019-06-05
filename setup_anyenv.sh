#! /bin/sh
git clone https://github.com/riywo/anyenv ~/.anyenv

exec $SHELL -l

anyenv install goenv
anyenv install rbenv

rbenv install 2.6.3
goenv install 1.12.1
