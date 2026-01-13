
# Environment Variables
export TERM=xterm-256color
export EDITOR=vim

# History Settings (Bash/Zsh common mostly, but check shell)
export HISTCONTROL="ignoredups:erasedups"
export HISTIGNORE="history:ls:ll:la:stage0-kubectl*"
export HISTSIZE=10000
export HISTFILESIZE=10000

# Go
export GOPATH=${HOME}/go
export PATH="/usr/local/go/bin:${PATH}"
export PATH="${GOPATH}/bin:${PATH}"

# Local bin
export PATH="${HOME}/.local/bin:${PATH}"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="${HOME}/bin:${PATH}"

# Aqua
export PATH="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH"
export AQUA_GLOBAL_CONFIG=${XDG_CONFIG_HOME:-$HOME/.config}/aquaproj-aqua/aqua.yaml

# Browser
export BROWSER="wslview"
