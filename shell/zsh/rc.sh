
# Load common configs
DOTFILES_ROOT="${HOME}/MyDotFiles"
source "${DOTFILES_ROOT}/shell/exports.sh"
source "${DOTFILES_ROOT}/shell/utils.sh"
source "${DOTFILES_ROOT}/shell/aliases.sh"

# Load functions
for f in ${DOTFILES_ROOT}/shell/functions/*.sh; do
    source "$f"
done

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Starship
eval "$(starship init zsh)"
