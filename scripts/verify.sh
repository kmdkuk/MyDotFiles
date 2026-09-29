#!/usr/bin/env bash
set -e

echo "Starting verification..."

dotfiles_home="${HOME}/MyDotFiles"
source "${dotfiles_home}/scripts/links.sh"

# 1. Check Symlinks
echo "Checking symlinks..."
LINKS=()
for entry in "${DOTFILES_LINKS[@]}"; do
    LINKS+=("${HOME}/${entry#*:}")
done
if [ "$(uname)" == 'Darwin' ]; then
    for entry in "${DOTFILES_LINKS_DARWIN[@]}"; do
        LINKS+=("${HOME}/${entry#*:}")
    done
else
    for entry in "${DOTFILES_LINKS_LINUX[@]}"; do
        LINKS+=("${HOME}/${entry#*:}")
    done
fi

for link in "${LINKS[@]}"; do
    if [ -L "$link" ]; then
        echo "OK: $link is a symlink"
    else
        echo "ERROR: $link is NOT a symlink"
        exit 1
    fi
done


# 2. Check Shell Loading (Bash)
echo "Checking bash loading..."
# Run bash with FORCE_LOAD=1 to bypass interactive check
FORCE_LOAD=1 bash -c "source $HOME/.bashrc && echo 'Bash loaded successfully'" > /dev/null 2>&1 || {
    echo "ERROR: Failed to load .bashrc"
    exit 1
}
echo "OK: Bash loaded successfully"

# 3. Check Environment Variables
echo "Checking environment variables..."
# Capture env
ENV_OUTPUT=$(FORCE_LOAD=1 bash -c "source $HOME/.bashrc && env")

if echo "$ENV_OUTPUT" | grep -q "GOPATH="; then
    echo "OK: GOPATH is set"
else
    echo "ERROR: GOPATH is not set"
    exit 1
fi

if echo "$ENV_OUTPUT" | grep -q "DOTFILES_ROOT="; then
    echo "OK: DOTFILES_ROOT is set"
else
    echo "ERROR: DOTFILES_ROOT is not set"
    exit 1
fi

# 4. Check Functions
echo "Checking functions..."
if FORCE_LOAD=1 bash -c "source $HOME/.bashrc && type ghq-cd" > /dev/null 2>&1; then
    echo "OK: ghq-cd function exists"
else
    echo "ERROR: ghq-cd function missing"
    exit 1
fi

echo "Verification passed!"
