#!/bin/bash

# Set strict error handling
set -euo pipefail

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Backup existing configurations
backup_configs() {
    local backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    log_info "Creating backup directory at $backup_dir"
    mkdir -p "$backup_dir"
    
    # List of files to backup
    local files=(".zshrc" ".tmux.conf" ".config/nvim" ".config/yabai" ".config/skhd")
    
    for file in "${files[@]}"; do
        if [ -e "$HOME/$file" ]; then
            log_info "Backing up $file"
            cp -R "$HOME/$file" "$backup_dir/"
        fi
    done
}

# Install Xcode Command Line Tools
install_xcode_tools() {
    if ! xcode-select -p &> /dev/null; then
        log_info "Installing Xcode Command Line Tools..."
        xcode-select --install
        read -p "Press enter after the Xcode Command Line Tools installation completes"
    else
        log_info "Xcode Command Line Tools already installed"
    fi
}

# Install Homebrew
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == 'arm64' ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        log_info "Homebrew already installed"
    fi
}

# Install Oh My Zsh and plugins
install_zsh_plugins() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        log_info "Oh My Zsh already installed"
    fi

    # Install/update plugins
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

# Install Homebrew packages
install_packages() {
    log_info "Tapping additional Homebrew formulae..."
    brew tap FelixKratz/formulae
    
    # Define package groups
    local cli_tools=(
        bat
        eza
        fastfetch
        fzf
        git
        starship
        tmux
        zoxide
    )
    
    local development_tools=(
        jenv
        mvnvm
        nvm
        uv
    )
    
    local window_management=(
        koekeishiya/formulae/yabai
        koekeishiya/formulae/skhd
        borders
        sketchybar
    )
    
    local shells_and_prompts=(
        zsh
    )
    
    local fonts=(
        font-jetbrains-mono-nerd-font
    )
    
    # Install all package groups
    log_info "Installing CLI tools..."
    brew install "${cli_tools[@]}"
    
    log_info "Installing development tools..."
    brew install "${development_tools[@]}"
    
    log_info "Installing window management tools..."
    brew install "${window_management[@]}"
    
    log_info "Installing shells and prompts..."
    brew install "${shells_and_prompts[@]}"
    
    log_info "Installing fonts..."
    brew install "${fonts[@]}"
}

# Setup dotfiles
setup_dotfiles() {
    local dotfiles_dir="$HOME/dotfile"
    
    if [ ! -d "$dotfiles_dir" ]; then
        log_info "Cloning dotfiles repository..."
        git clone git@github.com:RocGod/dotfile.git "$dotfiles_dir"
    fi
    
    log_info "Stowing dotfiles..."
    cd "$dotfiles_dir"
    stow .
}

main() {
    log_info "Starting installation..."
    
    # Create backup
    backup_configs
    
    # Run installation steps
    install_xcode_tools
    install_homebrew
    install_zsh_plugins
    install_packages
    setup_dotfiles
    
    log_info "Installation complete! Please restart your terminal."
    exec zsh
}

# Run the script
main