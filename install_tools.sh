#!/usr/bin/env bash

if which go > /dev/null 2>&1; then
  go install github.com/b4b4r07/git-bump@master
else
  echo "not found go"
fi

