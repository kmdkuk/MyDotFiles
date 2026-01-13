
# Common Aliases

# ls aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if [ -z "$(command -v nvim)" ]; then
  alias vim='nvim'
fi

alias sudo='sudo -E '

# kubectl aliases
alias kc='kubectl ctx | peco | xargs kubectl ctx'
alias kn='kubectl ns | peco | xargs kubectl ns'
alias stage0-kubectl="kubectl --kubeconfig=$HOME/.kube/stage0.config"

# git aliases
alias git-delete-squashed-main='git checkout -q main && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base main $branch) && [[ $(git cherry main $(git commit-tree $(git rev-parse $branch\^{tree}) -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done'
alias git-delete-squashed-master='git checkout -q master && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base master $branch) && [[ $(git cherry master $(git commit-tree $(git rev-parse $branch\^{tree}) -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done'
alias g='git'

# docker aliases
alias exec-ubuntu="docker run --rm -it --name=ubuntu quay.io/cybozu/ubuntu:20.04 bash"
alias exec-ubuntu-debug="docker run --rm -it --name=ubuntu quay.io/cybozu/ubuntu-debug:20.04 bash"

# Tool-specific replacements (depend on check-cmd)
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
