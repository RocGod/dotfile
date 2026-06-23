# =============================================================================
# justfile — macOS dotfile installer
# Usage:  just install      (full setup)
#         just <recipe>     (individual step)
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

# ── Individual steps ──────────────────────────────────────────────────────────

# Back up existing config files
backup:
    #!/usr/bin/env zsh
    set -euo pipefail
    backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    files=(.zshrc .config/nvim .config/aerospace .config/ghostty .config/starship.toml .config/borders)
    files_exist=false
    for f in "${files[@]}"; do
        [[ -e "$HOME/$f" ]] && files_exist=true && break
    done
    if [[ "$files_exist" == true ]]; then
        echo "\033[0;32m[INFO]\033[0m Creating backup at $backup_dir"
        mkdir -p "$backup_dir"
        for f in "${files[@]}"; do
            if [[ -e "$HOME/$f" ]]; then
                echo "\033[0;32m[INFO]\033[0m Backing up $f"
                cp -R "$HOME/$f" "$backup_dir/"
            fi
        done
    fi

# Install Xcode Command Line Tools
xcode:
    #!/usr/bin/env zsh
    set -euo pipefail
    if xcode-select -p &>/dev/null; then
        echo "\033[0;32m[INFO]\033[0m Xcode Command Line Tools already installed"
    else
        echo "\033[0;32m[INFO]\033[0m Installing Xcode Command Line Tools..."
        xcode-select --install
        echo "\033[0;32m[INFO]\033[0m Waiting for installation to finish..."
        until xcode-select -p &>/dev/null; do sleep 5; done
    fi

# Install Homebrew
homebrew:
    #!/usr/bin/env zsh
    set -euo pipefail
    if command -v brew &>/dev/null; then
        echo "\033[0;32m[INFO]\033[0m Homebrew already installed"
    else
        echo "\033[0;32m[INFO]\033[0m Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [[ $(uname -m) == 'arm64' ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi

# Install Homebrew packages (formulae + casks)
packages:
    @echo "{{GREEN}}[INFO]{{NC}} Tapping additional Homebrew formulae..."
    brew tap FelixKratz/formulae
    @echo "{{GREEN}}[INFO]{{NC}} Installing packages..."
    brew install \
        bat eza fastfetch fd fzf git just starship stow zoxide \
        jenv mvnvm fnm uv borders zsh \
        font-jetbrains-mono-nerd-font
    @echo "{{GREEN}}[INFO]{{NC}} Installing optional packages..."
    brew list trash-cli &>/dev/null || brew install trash-cli  || echo "Skipped trash-cli"
    brew list ripgrep   &>/dev/null || brew install ripgrep    || echo "Skipped ripgrep"
    brew list neovim    &>/dev/null || brew install neovim     || echo "Skipped neovim"

# Install Oh My Zsh and plugins
zsh-plugins:
    #!/usr/bin/env zsh
    set -euo pipefail
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        echo "\033[0;32m[INFO]\033[0m Oh My Zsh already installed"
    else
        echo "\033[0;32m[INFO]\033[0m Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    declare -A plugins=(
        [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
        [fast-syntax-highlighting]="https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
    )
    for name url in "${(@kv)plugins}"; do
        if [[ -d "$plugins_dir/$name" ]]; then
            echo "\033[0;32m[INFO]\033[0m $name already installed"
        else
            echo "\033[0;32m[INFO]\033[0m Installing $name..."
            git clone "$url" "$plugins_dir/$name"
        fi
    done
    if [[ -d "$plugins_dir/zsh-syntax-highlighting" ]]; then
        echo "\033[0;32m[INFO]\033[0m Removing conflicting zsh-syntax-highlighting..."
        rm -rf "$plugins_dir/zsh-syntax-highlighting"
    fi

# Clone dotfiles repo and stow everything
dotfiles:
    #!/usr/bin/env zsh
    set -euo pipefail
    dotfiles_dir="$HOME/dotfile"
    if [[ ! -d "$dotfiles_dir" ]]; then
        echo "\033[0;32m[INFO]\033[0m Cloning dotfiles repository..."
        git clone https://github.com/RocGod/dotfile.git "$dotfiles_dir"
    fi
    echo "\033[0;32m[INFO]\033[0m Stowing dotfiles..."
    cd "$dotfiles_dir" && stow .
    echo "\033[0;32m[INFO]\033[0m Creating zsh cache directory..."
    mkdir -p "$HOME/.zsh/cache"

# ── Maintenance ───────────────────────────────────────────────────────────────

# Update Homebrew packages
update:
    brew update
    brew upgrade
    brew cleanup

# Re-stow dotfiles after changes
restow:
    cd {{justfile_directory()}} && stow --restow .

# Show what stow would do without applying
stow-dry:
    cd {{justfile_directory()}} && stow --simulate --verbose .
