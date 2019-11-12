# 少し凝った zshrc
# License : MIT
# http://mollifier.mit-license.org/

########################################
# 環境変数
export PATH=/usr/local/bin:$PATH
export LANG=ja_JP.UTF-8

# 色を使用出来るようにする
autoload -Uz colors
colors

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

########################################
# 補完
# 補完機能を有効にする

# 補完ロード
if [ -e ~/.zsh/completions ]; then
  fpath=(~/.zsh/completions $fpath)
fi

if [ -e ~/.zsh/zsh-completions/src ]; then
  fpath=(~/.zsh/zsh-completions/src $fpath)
fi

if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi

autoload -U compinit
compinit

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'


########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

########################################
# キーバインド

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward

########################################
# エイリアス

alias la='ls -a'
alias ll='ls -l'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'

# ------------------------------------
# Docker aliases
# ------------------------------------

alias d="docker"

# Get the latest container ID
alias dl="docker ps --latest --quiet"

# List containers
alias dps="docker ps"

# List containers including stopped containers
alias dpa="docker ps --all"

# List images
alias di="docker images"

# List images including intermediates
alias dia="docker images --all"

# Tree images including intermediates
alias dit="docker images --tree"

# Get an IPaddress of a container
alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"

# Run a daemonized container
alias drd="docker run --detach --publish-all"

# Run an interactive container 
alias dri="docker run --interactive --tty --publish-all"

# Remove all containers
alias drm='docker rm $(docker ps --all --quiet)'

# Remove all images
alias drmi='docker rmi $(docker images --quiet)'

# Remove all containers and images by force
alias dclean='docker kill $(docker ps --all --quiet); drm; drmi;'

# List all aliases relating to docker
dalias() { alias | grep 'docker' | sed "s/^\([^=]*\)='\(.*\)'/\1    => \2/"| sed "s/'\\\'//g"; }

alias dc='docker-compose'

# ruby alias
alias be='bundle exec'

# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi


########################################
# OS 別の設定
case ${OSTYPE} in
    darwin*)
        #Mac用の設定
        export CLICOLOR=1
        alias ls='gls -G -F --color=auto'
        path=(
          /usr/local/opt/coreutils/libexec/gnubin(N-/) # coreutils
          /usr/local/opt/ed/libexec/gnubin(N-/) # ed
          /usr/local/opt/findutils/libexec/gnubin(N-/) # findutils
          /usr/local/opt/gnu-sed/libexec/gnubin(N-/) # sed
          /usr/local/opt/gnu-tar/libexec/gnubin(N-/) # tar
          /usr/local/opt/grep/libexec/gnubin(N-/) # grep
          ${path}
        )
        manpath=(
          /usr/local/opt/coreutils/libexec/gnuman(N-/) # coreutils
          /usr/local/opt/ed/libexec/gnuman(N-/) # ed
          /usr/local/opt/findutils/libexec/gnuman(N-/) # findutils
          /usr/local/opt/gnu-sed/libexec/gnuman(N-/) # sed
          /usr/local/opt/gnu-tar/libexec/gnuman(N-/) # tar
          /usr/local/opt/grep/libexec/gnuman(N-/) # grep
          ${manpath}
        )
        ;;
    linux*)
        #Linux用の設定
        alias ls='ls -F --color=auto'
        ;;
esac

# vim:set ft=zsh:

# JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

#   typeset
#    -U 重複パスを登録しない
#    -x exportも同時に行う
#    -T 環境変数へ紐付け
#
#   path=xxxx(N-/)
#     (N-/): 存在しないディレクトリは登録しない
#     パス(...): ...という条件にマッチするパスのみ残す
#        N: NULL_GLOBオプションを設定。
#           globがマッチしなかったり存在しないパスを無視する
#        -: シンボリックリンク先のパスを評価
#        /: ディレクトリのみ残す
#        .: 通常のファイルのみ残す

## 重複パスを登録しない
typeset -U path cdpath fpath manpath

## sudo用のpathを設定
typeset -xT SUDO_PATH sudo_path
typeset -U sudo_path
sudo_path=({/usr/local,/usr,}/sbin(N-/))

## pathを設定
path=(~/bin(N-/) /usr/local/bin(N-/) ${path})

## [ -f ~/.bundler-exec.sh ] && source ~/.bundler-exec.sh

function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

function tmux_automatically_attach_session()
{
    if is_screen_or_tmux_running; then
        ! is_exists 'tmux' && return 1

        if is_tmux_runnning; then
            echo "${fg_bold[red]} _____ __  __ _   ___  __ ${reset_color}"
            echo "${fg_bold[red]}|_   _|  \/  | | | \ \/ / ${reset_color}"
            echo "${fg_bold[red]}  | | | |\/| | | | |\  /  ${reset_color}"
            echo "${fg_bold[red]}  | | | |  | | |_| |/  \  ${reset_color}"
            echo "${fg_bold[red]}  |_| |_|  |_|\___//_/\_\ ${reset_color}"
        elif is_screen_running; then
            echo "This is on screen."
        fi
    else
        if shell_has_started_interactively && ! is_ssh_running; then
            if ! is_exists 'tmux'; then
                echo 'Error: tmux command not found' 2>&1
                return 1
            fi

            if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -q 'created'; then
                # detached session exists
                tmux list-sessions
                echo -n "Tmux: attach? (y/N/num) "
                read
                if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
                    tmux attach-session
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
                    tmux attach -t "$REPLY"
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                fi
            fi

            if is_osx && is_exists 'reattach-to-user-namespace'; then
                # on OS X force tmux's default command
                # to spawn a shell in the user's namespace
                tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
                tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
            else
                tmux new-session && echo "tmux created new session"
            fi
        fi
    fi
}
tmux_automatically_attach_session

eval "$(hub alias -s)"
export PATH=/usr/local/opt/openssl/bin:$PATH

## setting for go
export GO111MODULE=on

export PATH=$HOME/bin:$PATH

## setting for anyenv
export ANYENV_ROOT="${HOME}/.anyenv"
if [ -d $ANYENV_ROOT ]; then
  export PATH="$ANYENV_ROOT/bin:$PATH"
  for D in `command ls $ANYENV_ROOT/envs`
  do
    export PATH="$ANYENV_ROOT/envs/$D/shims:$PATH"
  done
fi

function anyenv_init() {
  eval "$(anyenv init - --no-rehash)"
}
function anyenv_unset() {
  unset -f nodenv
  unset -f rbenv
  unset -f goenv
}
function nodenv() {
  anyenv_unset
  anyenv_init
  nodenv "$@"
}
function rbenv() {
  anyenv_unset
  anyenv_init
  rbenv "$@"
}

function goenv() {
  anyenv_unset
  anyenv_init
  goenv "$2"
}

function ghq-new() {
    local REPONAME=$1

    if [ -z "$REPONAME" ]; then
        echo 'Repository name must be specified.'
        return
    fi

    local TMPDIR=/tmp/ghq_new
    local TMPREPODIR=$TMPDIR/$REPONAME

    mkdir -p $TMPREPODIR
    cd $TMPREPODIR

    hub init
    hub create

    local REPOURL=$(git remote get-url origin)
    local REPOPATH=$(echo $REPOURL | sed -e 's/^https:\/\///' -e 's/^git@//' -e 's/\.git$//' -e 's/github.com:/github.com\//')
    local USER_REPO_NAME=$(echo $REPOPATH | sed -e 's/^github\.com\///')

    ghq get $USER_REPO_NAME

    cd $(ghq root)/$REPOPATH

    rm -rf $TMPREPODIR
}
export PATH="/usr/local/opt/llvm/bin:$PATH"

export EDITOR="vim"
export PATH="${HOME}/bin:$PATH"
alias sudo='sudo -E'

# linux
# eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

#peco
function peco-history-selection() {
    BUFFER=$(history 1 | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\*?\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | peco --query "$LBUFFER")
    CURSOR=${#BUFFER}
    zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

