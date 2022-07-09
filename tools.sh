#!/usr/bin/env bash

if which go > /dev/null 2>&1; then
  go install github.com/b4b4r07/git-bump@master
else
  echo "not found go"
fi

curl -sS https://starship.rs/install.sh | sh
curl -sS https://webinstall.dev/k9s | bash
