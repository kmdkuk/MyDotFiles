
function git-cd-root() {
    cd "$(git rev-parse --show-superproject-working-tree --show-toplevel | head -1)"
}
