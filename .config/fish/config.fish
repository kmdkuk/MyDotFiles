alias d="docker"
alias dc="docker-compose"
alias git='hub'
alias vim='nvim'
alias flutter='fvm flutter'
set -x EDITOR "vim"
set -x PATH $HOME/.anyenv/bin $PATH
set -x PATH $HOME/bin $PATH
set -x PATH $HOME/.pub-cache/bin $PATH
set -x PATH $HOME/fvm/default/bin $PATH


# theme-bobthefish
set -g theme_nerd_fonts yes
set -g heme_use_abbreviated_branch_name no
set -g theme_newline_cursor yes
set -g theme_display_git_master_branch yes
set -g theme_display_git_ahead_verbose yes
set -g theme_display_git_dirty_verbose yes
set -g theme_display_git_stashed_verbose yes
set -g theme_title_display_process yes
set -g theme_color_scheme nord

status --is-interactive; and source (anyenv init -|psub)
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths
