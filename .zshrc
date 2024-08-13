# # Enable ohmyposh instant prompt. Should stay close to the top of ~/.zshrc.
# # Initialization code that may require console input (password prompts, [y/n]
# # confirmations, etc.) must go above this block; everything else may go below.
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/base.json)"
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/base.json)"
fi
# ----------------------
# oh-my-zsh config
# ----------------------
zstyle ':omz:update' mode auto  
ENABLE_CORRECTION="true"

plugins=(
	brew
  fzf
  git
  jenv
  mvn
  nvm
  thefuck
  zoxide
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"

nvm use default

# Sketchybar interactivity overloads
function brew() {
  command brew "$@" 

  if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]]; then
    sketchybar --trigger brew_update
  fi
}

# ----------------------
# Pyenv Config
# ----------------------
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# -----------------------------
# ----- Bat (better cat) -----
# -----------------------------
export BAT_THEME=Nord

# ----------------------
# eza --> (better ls)
# ----------------------
alias ls='eza -la --all --icons=always'

# ----------------------
# z --> (better cd)
# ----------------------
alias cd='z'

# Start fast fetch
fastfetch