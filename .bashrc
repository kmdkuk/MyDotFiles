# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoredups:erasedups

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

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

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

eval "$(hub alias -s)"

if [ "$(uname)" == 'Darwin' ]; then
  alias sed='gsed'
fi

export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTIGNORE="stage0-kubectl*"

# utility

peco_search_history() {
    local l=$(HISTTIMEFORMAT= history | \
                  sort -r | \
                  sed -e 's/^[0-9\| ]\+//' -e 's/ \+$//' | \
                  peco --query "$READLINE_LINE")
    READLINE_LINE="$l"
    READLINE_POINT=${#l}
}
bind -x '"\C-r": peco_search_history'

function ghq-cd() {
  cd "$( ghq list --full-path | sort | peco)"
}

function ghq-get() {
  name="kmdkuk"
  if [ -n "$1" ]; then
    name=$1
  fi
  url="$(gh repo list $name -L 1000 --json url --jq '.[].url' | sort | peco)"
  if [ -n "$url" ]; then
    ghq get $url
  fi
}

function tshlogin () {
  tsh login --proxy=teleport.${1:-stage0}.cybozu-ne.co:443 --auth=github --out $HOME/.kube/${1:-stage0}.config --format kubernetes
  source <(kubectl completion bash)
}

function tshssh () {
  tsh ssh --proxy=teleport.${1:-stage0}.cybozu-ne.co:443 --auth=github cybozu@${1:-stage0}-${2:-boot-0}
}

function argocdlogin () {
  argocd login argocd.${1:-stage0}.cybozu-ne.co --sso
}

function neco-test-ssh () {
  gcloud beta compute ssh --zone "asia-northeast1-c" "cybozu@${1}" --project "neco-test"
}

function neco-dev-ssh () {
  gcloud beta compute ssh --zone "asia-northeast1-c" "cybozu@${1}" --project "neco-dev"
}

# load completion

function load_completion () {
  if which $1 > /dev/null 2>&1; then
    source <($2)
  fi
  if [ -f $1 ]; then
    source $1
  fi
}

load_completion /usr/local/share/bash-completion/bash_completion
load_completion /usr/local/etc/bash_completion
load_completion $HOME/.asdf/asdf.sh
load_completion $HOME/.asdf/completions/asdf.bash
load_completion aqua "aqua completion bash"
load_completion kubectl "kubectl completion bash"
load_completion kubebuilder "kubebuilder completion bash"
load_completion kubectl-accurate "kubectl-accurate completion bash"
load_completion gh "gh completion -s bash"

# check dotfiles

function check_dirty () {
  dotfiles_home="$HOME/MyDotFiles"
  status="$(git -C ${dotfiles_home} status --porcelain)"
  diff="$(git -C ${dotfiles_home} diff --stat --cached origin/master)"
  if [ -z "$status" ] && [ -z "$diff" ]; then
    git -C ${dotfiles_home} fetch origin > /dev/null
    origin_diff="$(git -C ${dotfiles_home} diff --stat --cached origin/master)"
    if [ -z "$origin_diff" ]; then
      git -C ${dotfiles_home} pull origin master
    fi
    return
  fi
  echo -e "\e[36m=== DOTFILES IS DIRTY ===\e[m"
  echo -e "\e[33mThe dotfiles have been changed.\e[m"
  echo -e "\e[36m=========================\e[m"
}
check_dirty

# for starship
eval "$(starship init bash)"

