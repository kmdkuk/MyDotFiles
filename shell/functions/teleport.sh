
function tshlogin() {
    tsh login --proxy=teleport.${1:-stage0}.cybozu-ne.co:443 --auth=github --out $HOME/.kube/${1:-stage0}.config --format kubernetes
    source <(kubectl completion bash)
}

function tshssh() {
    tsh ssh --proxy=teleport.${1:-stage0}.cybozu-ne.co:443 --auth=github cybozu@${1:-stage0}-${2:-boot-0}
}
