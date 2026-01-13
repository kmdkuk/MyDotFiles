
# check dotfiles
function check_dirty_and_update() {
    dotfiles_home="$HOME/MyDotFiles"
    status="$(git -C ${dotfiles_home} status --porcelain)"
    diff="$(git -C ${dotfiles_home} diff --stat --cached origin/master)"
    if [ -z "$status" ] && [ -z "$diff" ]; then
        # Check last fetch time to avoid frequent fetching
        local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}"
        local last_fetch_file="$cache_dir/dotfiles_last_fetch"
        local current_time=$(date +%s)
        local fetch_interval=${DOTFILES_FETCH_INTERVAL:-3600} # Default 1 hour

        if [ -f "$last_fetch_file" ]; then
            local last_fetch=$(cat "$last_fetch_file")
            if [ $((current_time - last_fetch)) -lt $fetch_interval ]; then
                return
            fi
        fi

        git -C ${dotfiles_home} fetch origin >/dev/null
        # Update last fetch time
        echo "$current_time" > "$last_fetch_file"

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
