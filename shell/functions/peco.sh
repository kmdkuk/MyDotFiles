
function peco_search_history() {
    local l=$(HISTTIMEFORMAT= history |
        sort -r |
        sed -e 's/^[0-9\| ]\+//' -e 's/ \+$//' |
        awk '!a[$0]++' |
    peco --query "$READLINE_LINE")
    READLINE_LINE="$l"
    READLINE_POINT=${#l}
}
