
function ghq-cd() {
    cd "$(ghq list --full-path | sort | peco)"
}
