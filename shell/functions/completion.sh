
# load completion
function load_completion() {
    local target=$1
    local gen_cmd=$2
    local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/bash_completion"

    # If generation command is provided, use cache
    if [ -n "$gen_cmd" ]; then
        if ! check-cmd "$target"; then
            return
        fi

        mkdir -p "$cache_dir"
        local cache_file="$cache_dir/$target.bash"

        if [ ! -f "$cache_file" ]; then
            # echo "Generating completion for $target..."
            # Use eval to execute the generation command string
            if ! eval "$gen_cmd" > "$cache_file"; then
                rm -f "$cache_file"
                return
            fi
        fi
        
        source "$cache_file"
        return
    fi

    # Fallback to existing logic (sourcing file directly)
    if [ -f "$target" ]; then
        source "$target"
    elif check-cmd "$target"; then
        # This branch seems unused based on rc.sh usage but kept for compatibility just in case
        : "load $target"
        # source <($target) # This was the old eval-like behavior without gen_cmd
    fi
}
