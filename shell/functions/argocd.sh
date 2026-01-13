
function argocdlogin() {
    argocd login argocd.${1:-stage0}.cybozu-ne.co --sso
}
