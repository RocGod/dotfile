#!/bin/bash

set -euo pipefail

GREEN='\033[0;32m'
NC='\033[0m'
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }

backup_configs() {
    local backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    local files=(".zshrc" ".tmux.conf" ".config/nvim" ".config/yabai" ".config/skhd")
    local created=0

    for file in "${files[@]}"; do
        if [ -e "$HOME/$file" ]; then
            if [ "$created" -eq 0 ]; then
                log_info "Creating backup directory at $backup_dir"
                mkdir -p "$backup_dir"
                created=1
            fi
            log_info "Backing up $file"
            cp -R "$HOME/$file" "$backup_dir/"
        fi
    done
}

install_xcode_tools() {
    if xcode-select -p &> /dev/null; then
        log_info "Xcode Command Line Tools already installed"
        return
    fi

    log_info "Installing Xcode Command Line Tools..."
    xcode-select --install

    if [ -t 0 ]; then
        read -r -p "Press enter after the Xcode Command Line Tools installation completes"
    else
        log_info "Waiting for Xcode Command Line Tools installation to finish..."
        until xcode-select -p &> /dev/null; do
            sleep 5
        done
    fi
}

install_homebrew() {
    if command -v brew &> /dev/null; then
        log_info "Homebrew already installed"
        return
    fi

    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

install_zsh_plugins() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        log_info "Oh My Zsh already installed"
    fi

    local plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

    if [ ! -d "$plugins_dir/zsh-autosuggestions" ]; then
        log_info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$plugins_dir/zsh-autosuggestions"
    fi

    if [ ! -d "$plugins_dir/zsh-syntax-highlighting" ]; then
        log_info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugins_dir/zsh-syntax-highlighting"
    fi
}

install_packages() {
    log_info "Tapping additional Homebrew formulae..."
    brew tap FelixKratz/formulae

    local packages=(
        bat
        eza
        fastfetch
        fzf
        git
        starship
        stow
        tmux
        zoxide
        jenv
        mvnvm
        nvm
        uv
        koekeishiya/formulae/yabai
        koekeishiya/formulae/skhd
        borders
        sketchybar
        zsh
        font-jetbrains-mono-nerd-font
    )

    log_info "Installing Homebrew packages..."
    brew install "${packages[@]}"
}

setup_dotfiles() {
    local dotfiles_dir="$HOME/dotfile"

    if [ ! -d "$dotfiles_dir" ]; then
        log_info "Cloning dotfiles repository..."
        git clone https://github.com/RocGod/dotfile.git "$dotfiles_dir"
    fi

    log_info "Stowing dotfiles..."
    cd "$dotfiles_dir"
    stow .
}

main() {
    log_info "Starting installation..."

    backup_configs
    install_xcode_tools
    install_homebrew
    install_zsh_plugins
    install_packages
    setup_dotfiles

    log_info "Installation complete! Please restart your terminal."
    if [ -t 1 ]; then
        exec zsh
    fi
}

main
