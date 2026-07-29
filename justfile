# =============================================================================
# justfile — macOS dotfile installer
# Usage:  just install      (full setup)
#         just <recipe>     (individual step)
#
# Individual step recipes delegate into install.sh's functions instead of
# reimplementing them, so the install logic has exactly one source of truth.
# See install.sh for what each function actually does.
# =============================================================================

set shell := ["zsh", "-euo", "pipefail", "-c"]

GREEN := "\\033[0;32m"
NC    := "\\033[0m"

# Default: show available recipes
default:
    @just --list

# ── Full install ──────────────────────────────────────────────────────────────

# Run the complete setup from scratch
install: backup xcode homebrew packages zsh-plugins dotfiles
    @echo "{{GREEN}}[INFO]{{NC}} Installation complete! 🎉"
    @echo "{{GREEN}}[INFO]{{NC}} Next steps:"
    @echo "{{GREEN}}[INFO]{{NC}}   • Restart terminal or run: source ~/.zshrc"
    @echo "{{GREEN}}[INFO]{{NC}}   • Run 'brew cleanup' to remove old versions"

# ── Individual steps (delegate to install.sh) ───────────────────────────────────

# Internal: source install.sh and call a single function, without running main.
_run-step func:
    INSTALL_SH_NO_MAIN=1 bash -c 'source "{{justfile_directory()}}/install.sh" && {{func}}'

# Back up existing config files
backup: (_run-step "backup_configs")

# Install Xcode Command Line Tools
xcode: (_run-step "install_xcode_tools")

# Install Homebrew
homebrew: (_run-step "install_homebrew")

# Install Homebrew packages (formulae + casks)
packages: (_run-step "install_packages")

# Install Oh My Zsh and plugins
zsh-plugins: (_run-step "install_zsh_plugins")

# Clone dotfiles repo and stow everything
dotfiles: (_run-step "setup_dotfiles")

# ── Maintenance ───────────────────────────────────────────────────────────────

# Update Homebrew packages
update:
    brew update
    brew upgrade
    brew cleanup

# Re-stow dotfiles after changes
restow:
    mkdir -p ~/.zsh/cache
    cd {{justfile_directory()}} && stow --restow .

# Show what stow would do without applying
stow-dry:
    cd {{justfile_directory()}} && stow --simulate --verbose .
