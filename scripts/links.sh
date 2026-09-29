# Shared symlink manifest for setup.sh and scripts/verify.sh.
# Each entry is "source_relative_to_repo:dest_relative_to_HOME".
# Keep this as the single source of truth so setup.sh and verify.sh
# can never drift apart.

DOTFILES_LINKS=(
    # fish
    ".config/fish/config.fish:.config/fish/config.fish"
    "home/completions/asdf.fish:.config/fish/completions/asdf.fish"
    ".config/fish/functions/ghq-cd.fish:.config/fish/functions/ghq-cd.fish"
    ".config/fish/functions/check-update-dotfiles.fish:.config/fish/functions/check-update-dotfiles.fish"

    # bash/zsh
    "home/.bashrc:.bashrc"
    "home/.inputrc:.inputrc"
    "home/.zshrc:.zshrc"

    # starship
    ".config/starship.toml:.config/starship.toml"

    # erdtree
    ".config/erdtree.toml:.config/erdtree.toml"

    # gemini
    ".gemini/GEMINI.md:.gemini/GEMINI.md"
    ".gemini/v5.md:.gemini/v5.md"
    ".gemini/planning-mode-guard.md:.gemini/planning-mode-guard.md"
    ".gemini/commit-message-format.md:.gemini/commit-message-format.md"
    ".gemini/pr-message-format.md:.gemini/pr-message-format.md"
    ".gemini/commands:.gemini/commands"

    # claude
    ".claude/CLAUDE.md:.claude/CLAUDE.md"
    ".claude/WRITING.md:.claude/WRITING.md"
    ".claude/commands:.claude/commands"

    # codex
    ".codex/AGENTS.md:.codex/AGENTS.md"
    ".codex/prompts:.codex/prompts"

    # vim
    "home/.vimrc:.vimrc"

    # nvim
    ".config/nvim/init.lua:.config/nvim/init.lua"
    ".config/nvim/lua/lazy_nvim.lua:.config/nvim/lua/lazy_nvim.lua"
    ".config/nvim/lua/plugins.lua:.config/nvim/lua/plugins.lua"

    # git
    ".config/git/config:.config/git/config"
    ".config/git/template:.config/git/template"
    ".config/git/ignore:.config/git/ignore"
    ".config/git/work.config:.config/git/work.config"
    ".config/git/alias.config:.config/git/alias.config"
    "home/.ghqlist:.ghqlist"

    # tmux
    "home/.tmux/iceberg.tmux.conf:.tmux/iceberg.tmux.conf"
    "home/.tmux.conf:.tmux.conf"

    # aqua
    ".config/aquaproj-aqua/aqua.yaml:.config/aquaproj-aqua/aqua.yaml"
)

# macOS-only links (applied when uname == Darwin)
DOTFILES_LINKS_DARWIN=(
    "home/.Brewfile:.Brewfile"
    "home/.tmux/osx.tmux.conf:.tmux/local.tmux.conf"
    ".config/git/osx.config:.config/git/local.config"
)

# Linux-only links
DOTFILES_LINKS_LINUX=(
    "home/.tmux/linux.tmux.conf:.tmux/local.tmux.conf"
    ".config/git/linux.config:.config/git/local.config"
)
