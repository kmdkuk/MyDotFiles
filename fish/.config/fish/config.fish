alias d="docker"
alias dc="docker compose"
alias git='hub'
set -x EDITOR vim
set -x PATH $HOME/bin $PATH
set -x PATH /usr/local/opt/openssl@1.1/bin $PATH
set -x PATH /usr/local/go/bin $PATH
set -x GOPATH $HOME/go
set -x PATH $GOPATH/bin $PATH

set -g fish_user_paths /usr/local/sbin $fish_user_paths

if [ (uname) = Darwin ]
    # OSX
    echo "Welcom OSX"
    source /usr/local/opt/asdf/asdf.fish

    # ruby入れる時にbrew でいれたopensslを使ってもらうoption
    set -x RUBY_CONFIGURE_OPTS "--with-openssl-dir="(brew --prefix openssl)
else if [ (expr substr (uname -s) 1 5) = Linux ]
    # Linux
    echo "Welcom Linux"
    source ~/.asdf/asdf.fish
end

# Hook direnv into your shell.
# eval (asdf exec direnv hook fish)
if type direnv >/dev/null 2>&1
    direnv hook fish | source
else
    echo "not install direnv"
end

check-update-dotfiles

# Ctrl + Rで履歴検索
function peco_select_history_order
    if test (count $argv) = 0
        set peco_flags --layout=top-down
    else
        set peco_flags --layout=bottom-up --query "$argv"
    end

    history | peco $peco_flags | read foo

    if [ $foo ]
        commandline $foo
    else
        commandline ''
    end
end

function fish_user_key_bindings
    bind \cr peco_select_history_order # Ctrl + R
end
starship init fish | source

# Generated for envman. Do not edit.
test -s "$HOME/.config/envman/load.fish"; and source "$HOME/.config/envman/load.fish"

