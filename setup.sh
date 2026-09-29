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
    if [ -z "${1:-}" ] || [ -z "${2:-}" ]; then
        : "invalid args 1: ${1:-}, 2: ${2:-}"
        exit 1
    fi
    mkdir -p "$(dirname "${HOME}/${2}")"
    ln -sfn "${dotfiles_home}/${1}" "${HOME}/${2}"
}

function add-links() {
    # takes link entries ("src:dest") as positional args, not an array name,
    # since macOS's default /bin/bash (3.2) doesn't support `local -n`.
    local entry src dest
    for entry in "$@"; do
        src="${entry%%:*}"
        dest="${entry#*:}"
        add-link "$src" "$dest"
    done
}

source "${dotfiles_home}/scripts/links.sh"

: "prepare shimlink"
add-links "${DOTFILES_LINKS[@]}"

# each OS. support macOSOS or Linux
if [ "$(uname)" == 'Darwin' ]; then
    : "macOS"
    add-links "${DOTFILES_LINKS_DARWIN[@]}"
    # set defaults
    defaults write com.apple.finder CreateDesktop -boolean false
    killAll Finder
fi
if [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    : "Linux"
    add-links "${DOTFILES_LINKS_LINUX[@]}"
fi

: "bin"
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
