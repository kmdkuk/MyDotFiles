
# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return ;;
esac

# Check window size
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Load common configs
DOTFILES_ROOT="${HOME}/MyDotFiles"
source "${DOTFILES_ROOT}/shell/exports.sh"
source "${DOTFILES_ROOT}/shell/utils.sh"
source "${DOTFILES_ROOT}/shell/aliases.sh"

# Load functions
for f in ${DOTFILES_ROOT}/shell/functions/*.sh; do
    source "$f"
done

# Bash specific history settings
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
shopt -u histappend

# Bash specific aliases (if any, separate from common aliases)
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

if [ "$(uname)" == 'Darwin' ]; then
    load_completion /usr/local/etc/profile.d/bash_completion.sh
    load_completion /usr/local/etc/bash_completion.d/git-prompt.sh
    load_completion /usr/local/etc/bash_completion.d/git-completion.bash
else
    load_completion /usr/share/bash-completion/completions/git
fi
load_completion $HOME/.asdf/asdf.sh
load_completion $HOME/.asdf/completions/asdf.bash
load_completion aqua "aqua completion bash"
load_completion kubectl "kubectl completion bash"
load_completion kubebuilder "kubebuilder completion bash"
load_completion kubectl-accurate "kubectl-accurate completion bash"
load_completion gh "gh completion -s bash"
load_completion necogcp "necogcp completion"

alias g='git'
if type __git_complete &>/dev/null; then
  __git_complete g __git_main
fi

# Bindings
bind -x '"\C-r": peco_search_history'

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Starship
eval "$(starship init bash)"

# Check for updates
# check_dirty_and_update
