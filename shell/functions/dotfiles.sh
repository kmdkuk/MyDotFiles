
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
