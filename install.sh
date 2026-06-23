#!/bin/bash

set -euo pipefail
trap 'echo "Error on line $LINENO — exit code $?" >&2' ERR

GREEN='\033[0;32m'
NC='\033[0m'
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }

backup_configs() {
    local backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    local files=(
        ".zshrc"
        ".config/nvim"
        ".config/aerospace"
        ".config/ghostty"
        ".config/starship.toml"
        ".config/borders"
    )

    # Check if any files exist before creating backup directory
    local files_exist=false
    for file in "${files[@]}"; do
        if [[ -e "$HOME/$file" ]]; then
            files_exist=true
            break
        fi
    done

    if [[ "$files_exist" == true ]]; then
        log_info "Creating backup directory at $backup_dir"
        mkdir -p "$backup_dir"
        for file in "${files[@]}"; do
            if [[ -e "$HOME/$file" ]]; then
                log_info "Backing up $file"
                cp -R "$HOME/$file" "$backup_dir/"
            fi
        done
    fi
}

install_xcode_tools() {
    if xcode-select -p &>/dev/null; then
        log_info "Xcode Command Line Tools already installed"
        return
    fi

    log_info "Installing Xcode Command Line Tools..."
    xcode-select --install

    # Wait for installation to complete
    if [ -t 0 ]; then
        read -r -p "Press enter after installation completes"
    else
        log_info "Waiting for installation to finish..."
        until xcode-select -p &>/dev/null; do sleep 5; done
    fi
}

install_homebrew() {
    if command -v brew &>/dev/null; then
        log_info "Homebrew already installed"
        return
    fi

    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Setup Homebrew for Apple Silicon
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

install_packages() {
    log_info "Tapping additional Homebrew formulae..."
    brew tap FelixKratz/formulae

    local packages=(
        bat eza fastfetch fd fzf git just starship stow zoxide
        jenv mvnvm fnm uv borders zsh
    )

    log_info "Installing Homebrew packages..."
    for pkg in "${packages[@]}"; do
        if brew list "$pkg" &>/dev/null; then
            log_info "$pkg already installed"
        else
            brew install "$pkg"
        fi
    done

    log_info "Installing cask packages..."
    if brew list --cask font-jetbrains-mono-nerd-font &>/dev/null; then
        log_info "font-jetbrains-mono-nerd-font already installed"
    else
        brew install --cask font-jetbrains-mono-nerd-font
    fi

    log_info "Installing optional packages..."
    local optional_packages=(trash-cli ripgrep neovim)
    for pkg in "${optional_packages[@]}"; do
        if brew list "$pkg" &>/dev/null; then
            log_info "$pkg already installed"
        else
            brew install "$pkg" || log_info "Skipped $pkg"
        fi
    done
}

install_zsh_plugins() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Oh My Zsh already installed"
    else
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    local plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

    # Parallel arrays — compatible with bash 3.2 (macOS default)
    local plugin_names=(zsh-autosuggestions fast-syntax-highlighting)
    local plugin_urls=(
        "https://github.com/zsh-users/zsh-autosuggestions"
        "https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
    )

    for i in "${!plugin_names[@]}"; do
        if [[ -d "$plugins_dir/${plugin_names[$i]}" ]]; then
            log_info "${plugin_names[$i]} already installed"
        else
            log_info "Installing ${plugin_names[$i]}..."
            git clone --depth=1 "${plugin_urls[$i]}" "$plugins_dir/${plugin_names[$i]}"
        fi
    done

    # Remove conflicting plugin if it exists
    if [[ -d "$plugins_dir/zsh-syntax-highlighting" ]]; then
        log_info "Removing conflicting zsh-syntax-highlighting..."
        rm -rf "$plugins_dir/zsh-syntax-highlighting"
    fi
}

setup_dotfiles() {
    local dotfiles_dir="$HOME/dotfile"

    if [[ ! -d "$dotfiles_dir" ]]; then
        log_info "Cloning dotfiles repository..."
        git clone --depth=1 https://github.com/RocGod/dotfile.git "$dotfiles_dir"
    fi

    log_info "Stowing dotfiles..."
    (cd "$dotfiles_dir" && stow .)

    log_info "Creating zsh cache directory..."
    mkdir -p "$HOME/.zsh/cache"
}

main() {
    log_info "Starting installation..."

    backup_configs
    install_xcode_tools
    install_homebrew
    install_packages      # packages first — provides git, stow
    install_zsh_plugins   # needs git
    setup_dotfiles        # needs git, stow

    log_info "Installation complete! 🎉"
    log_info "Next steps:"
    log_info "  • Restart terminal or run: source ~/.zshrc"
    log_info "  • Run 'brew cleanup' to remove old versions"

    if [ -t 1 ]; then
        log_info "Launching new shell..."
        exec zsh
    fi
}

main
