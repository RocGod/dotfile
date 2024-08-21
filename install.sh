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

# Clone the dotfile repository
echo "Cloning the dotfile repository..."
git clone git@github.com:RocGod/dotfile.git
cd dotfile

# Install packages using Homebrew
brew install jandedobbeleer/oh-my-posh/oh-my-posh fzf git jenv mvnvm nvm thefuck tmux zoxide stow zsh yabai skhd bat pyenv sketchybar borders btop

stow .