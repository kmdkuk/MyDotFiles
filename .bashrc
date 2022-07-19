# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL="ignoredups:erasedups"
export HISTIGNORE="history:ls:ll:la:stage0-kubectl*"

# for sharing history(not default)
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
shopt -u histappend

# append to the history file, don't overwrite it
# shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

export TERM=xterm-256color
export EDITOR=vim

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# ここまでUbuntuデフォルト

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

export GOPATH=${HOME}/go
export PATH="/usr/local/go/bin:${PATH}"
export PATH="${GOPATH}/bin:${PATH}"

export PATH="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH"

export PATH="${HOME}/.local/bin:${PATH}"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="${HOME}/bin:${PATH}"

alias kc='kubectl ctx | peco | xargs kubectl ctx'
alias kn='kubectl ns | peco | xargs kubectl ns'

alias stage0-kubectl="kubectl --kubeconfig=$HOME/.kube/stage0.config"

alias git-delete-squashed-main='git checkout -q main && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base main $branch) && [[ $(git cherry main $(git commit-tree $(git rev-parse $branch\^{tree}) -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done'
alias git-delete-squashed-master='git checkout -q master && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base master $branch) && [[ $(git cherry master $(git commit-tree $(git rev-parse $branch\^{tree}) -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done'

alias exec-ubuntu="docker run --rm -it --name=ubuntu quay.io/cybozu/ubuntu:20.04 bash"
alias exec-ubuntu-debug="docker run --rm -it --name=ubuntu quay.io/cybozu/ubuntu-debug:20.04 bash"

function check-cmd() {
    if which $1 > /dev/null 2>&1;then
        return 0
    fi
    return 1
}

if check-cmd hub;then
    eval "$(hub alias -s)"
fi

if check-cmd exa;then
    alias ls='exa'
fi

if check-cmd bat;then
    alias cat='bat'
fi

if check-cmd batcat;then
    alias cat='batcat'
fi

if [ "$(uname)" == 'Darwin' ]; then
    alias sed='gsed'
fi

export HISTSIZE=10000
export HISTFILESIZE=10000

# utility

function ghq-cd() {
    cd "$(ghq list --full-path | sort | peco)"
}

function git-cd-root() {
    cd "$(git rev-parse --show-superproject-working-tree --show-toplevel | head -1)"
}

function peco_search_history() {
    local l=$(HISTTIMEFORMAT= history |
        sort -r |
        sed -e 's/^[0-9\| ]\+//' -e 's/ \+$//' |
    peco --query "$READLINE_LINE")
    READLINE_LINE="$l"
    READLINE_POINT=${#l}
}
bind -x '"\C-r": peco_search_history'

function tshlogin() {
    tsh login --proxy=teleport.${1:-stage0}.cybozu-ne.co:443 --auth=github --out $HOME/.kube/${1:-stage0}.config --format kubernetes
    source <(kubectl completion bash)
}

function tshssh() {
    tsh ssh --proxy=teleport.${1:-stage0}.cybozu-ne.co:443 --auth=github cybozu@${1:-stage0}-${2:-boot-0}
}

function argocdlogin() {
    argocd login argocd.${1:-stage0}.cybozu-ne.co --sso
}

function neco-test-ssh() {
    gcloud beta compute ssh --zone "asia-northeast1-c" "cybozu@${1}" --project "neco-test"
}

function neco-dev-ssh() {
    gcloud beta compute ssh --zone "asia-northeast1-c" "cybozu@${1}" --project "neco-dev"
}

# load completion

function load_completion() {
    if check-cmd $1; then
        : "load $2"
        source <($2)
    fi
    if [ -f $1 ]; then
        : "source $1"
        source $1
    fi
}

if [ "$(uname)" == 'Darwin' ]; then
    load_completion /usr/local/etc/profile.d/bash_completion.sh
    load_completion /usr/local/etc/bash_completion.d/git-prompt.sh
    load_completion /usr/local/etc/bash_completion.d/git-completion.bash
else
    load_completion /usr/share/bash-completion/completions/git
fi
load_completion /usr/share/bash-completion/bash_completion
load_completion $HOME/.asdf/asdf.sh
load_completion $HOME/.asdf/completions/asdf.bash
load_completion aqua "aqua completion bash"
load_completion kubectl "kubectl completion bash"
load_completion kubebuilder "kubebuilder completion bash"
load_completion kubectl-accurate "kubectl-accurate completion bash"
load_completion gh "gh completion -s bash"
load_completion necogcp "necogcp completion"
alias g='git'
__git_complete g __git_main

# check dotfiles

function check_dirty_and_update() {
    dotfiles_home="$HOME/MyDotFiles"
    status="$(git -C ${dotfiles_home} status --porcelain)"
    diff="$(git -C ${dotfiles_home} diff --stat --cached origin/master)"
    if [ -z "$status" ] && [ -z "$diff" ]; then
        git -C ${dotfiles_home} fetch origin >/dev/null
        origin_diff="$(git -C ${dotfiles_home} diff --stat --cached origin/master)"
        if [ -n "$origin_diff" ]; then
            echo "found MyDotFiles updated"
            echo "git -C ${dotfiles_home} pull origin master"
            git -C ${dotfiles_home} pull origin master >/dev/null
        fi
        return
    fi
    echo -e "\e[36m=== DOTFILES IS DIRTY ===\e[m"
    echo -e "\e[33mThe dotfiles have been changed.\e[m"
    echo -e "\e[36m=========================\e[m"
}

check_dirty_and_update

# for WSL
uname -a | grep -q "WSL"
if [ $? = 0 ]; then
    export BROWSER="/mnt/c/Program\ Files/Google/Chrome/Application/chrome.exe"
fi

# for starship
eval "$(starship init bash)"
