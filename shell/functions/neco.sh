
function neco-test-ssh() {
    gcloud beta compute ssh --zone "asia-northeast1-c" "cybozu@${1}" --project "neco-test"
}

function neco-dev-ssh() {
    gcloud beta compute ssh --zone "asia-northeast1-c" "cybozu@${1}" --project "neco-dev"
}
