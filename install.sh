#!/bin/bash

set -euo pipefail

GREEN='\033[0;32m'
NC='\033[0m'
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }

backup_configs() {
    local backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    local files=(".zshrc" ".config/nvim" ".config/aerospace" ".config/ghostty" ".config/starship.toml" ".config/borders" ".config/sketchybar")
    
    # Check if any files exist before creating backup directory
    local files_exist=false
    for file in "${files[@]}"; do
        [ -e "$HOME/$file" ] && files_exist=true && break
    done
    
    if [ "$files_exist" = true ]; then
        log_info "Creating backup directory at $backup_dir"
        mkdir -p "$backup_dir"
        
        for file in "${files[@]}"; do
            if [ -e "$HOME/$file" ]; then
                log_info "Backing up $file"
                cp -R "$HOME/$file" "$backup_dir/"
            fi
        done
    fi
}

install_xcode_tools() {
    xcode-select -p &>/dev/null && { log_info "Xcode Command Line Tools already installed"; return; }

    log_info "Installing Xcode Command Line Tools..."
    xcode-select --install

    # Wait for installation to complete
    [ -t 0 ] && read -r -p "Press enter after installation completes" || {
        log_info "Waiting for installation to finish..."
        until xcode-select -p &>/dev/null; do sleep 5; done
    }
}

install_homebrew() {
    command -v brew &>/dev/null && { log_info "Homebrew already installed"; return; }

    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Setup Homebrew for Apple Silicon
    [[ $(uname -m) == 'arm64' ]] && {
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    }
}

install_zsh_plugins() {
    # Install Oh My Zsh
    [ -d "$HOME/.oh-my-zsh" ] && log_info "Oh My Zsh already installed" || {
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    }

    local plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    
    # Install plugins using a loop
    local -A plugins=(
        ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
        ["fast-syntax-highlighting"]="https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
    )
    
    for plugin in "${!plugins[@]}"; do
        [ -d "$plugins_dir/$plugin" ] && log_info "$plugin already installed" || {
            log_info "Installing $plugin..."
            git clone "${plugins[$plugin]}" "$plugins_dir/$plugin"
        }
    done
    
    # Remove conflicting plugin if it exists
    [ -d "$plugins_dir/zsh-syntax-highlighting" ] && {
        log_info "Removing conflicting zsh-syntax-highlighting..."
        rm -rf "$plugins_dir/zsh-syntax-highlighting"
    }
}

install_packages() {
    log_info "Tapping additional Homebrew formulae..."
    brew tap FelixKratz/formulae

    local packages=(
        bat eza fastfetch fd fzf git starship stow zoxide
        jenv mvnvm fnm uv borders sketchybar zsh
        font-jetbrains-mono-nerd-font
    )

    local optional_packages=(trash-cli ripgrep neovim)

    log_info "Installing Homebrew packages..."
    brew install "${packages[@]}"

    log_info "Installing optional packages..."
    for pkg in "${optional_packages[@]}"; do
        brew list "$pkg" &>/dev/null || {
            log_info "Installing $pkg..."
            brew install "$pkg" 2>/dev/null || log_info "Skipped $pkg"
        }
    done
}

setup_dotfiles() {
    local dotfiles_dir="$HOME/dotfile"

    [ -d "$dotfiles_dir" ] || {
        log_info "Cloning dotfiles repository..."
        git clone https://github.com/RocGod/dotfile.git "$dotfiles_dir"
    }

    log_info "Stowing dotfiles..."
    cd "$dotfiles_dir" && stow .

    log_info "Creating zsh cache directory..."
    mkdir -p "$HOME/.zsh/cache"
}

main() {
    log_info "Starting installation..."

    backup_configs
    install_xcode_tools
    install_homebrew
    install_zsh_plugins
    install_packages
    setup_dotfiles

    log_info "Installation complete! 🎉"
    log_info "Next steps:"
    log_info "  • Restart terminal or run: source ~/.zshrc"
    log_info "  • Run 'brew cleanup' to remove old versions"
    
    [ -t 1 ] && exec zsh
}

main
