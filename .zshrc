#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
source ~/.github.zshrc
export PATH="/usr/local/Cellar/llvm/9.0.0/bin:$PATH"
SYSROOT='/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk'
# alias clang="clang --sysroot=${SYSROOT}"
# alias clang++="clang++ --sysroot=${SYSROOT}"
# alias clangd="clangd --sysroot=${SYSROOT}"

export SDKROOT="$(xcrun --sdk macosx --show-sdk-path)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh