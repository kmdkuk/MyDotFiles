
# load completion
function load_completion() {
    if check-cmd $1; then
        : "load $2"
        source <($2)
    fi
    if [ -f $1 ]; then
        : "source $1"
        source $1
    fi
}
