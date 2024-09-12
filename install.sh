# Check if Xcode Command Line Tools are installed
if ! xcode-select -p &> /dev/null
then
    echo "Xcode Command Line Tools not found. Installing..."
    xcode-select --install
else
    echo "Xcode Command Line Tools are already installed."
fi

# Check if Homebrew is installed
if ! command -v brew &> /dev/null
then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "oh-my-zsh is already installed."
fi

# Install zsh-autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install zsh-syntax-highlighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Clone the dotfile repository
echo "Cloning the dotfile repository..."
git clone git@github.com:RocGod/dotfile.git

# Tap additional Homebrew formulae
brew tap FelixKratz/formulae

# Install packages using Homebrew
brew install font-jetbrains-mono-nerd-font jandedobbeleer/oh-my-posh/oh-my-posh fzf git jenv mvnvm nvm thefuck tmux zoxide stow zsh koekeishiya/formulae/yabai koekeishiya/formulae/skhd bat pyenv sketchybar borders btop eza fastfetch starship

# Stow dotfiles
cd dotfile
stow .

# Start zsh
exec zsh