# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ----------------------
# oh-my-zsh config
# ----------------------
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Path to your oh-my-zsh installation.
# export ZSH="$HOME/.oh-my-zsh"

alias config='/opt/homebrew/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no

zstyle ':omz:update' mode auto  
ENABLE_CORRECTION="true"

plugins=(git
	brew
	npm
)

alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ----------------------
# nvm config
# ----------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm 

nvm use default

# Sketchybar interactivity overloads
function brew() {
  command brew "$@" 

  if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]]; then
    sketchybar --trigger brew_update
  fi
}

# ----------------------
# Java Env
# ----------------------
eval "$(jenv init -)"

# ----------------------
# Python Env
# ----------------------
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# -----------------------------
# ----- Bat (better cat) -----
# -----------------------------
export BAT_THEME=tokyonight_night

# ----------------------
# eza --> (better ls)
# ----------------------
alias ls='eza -la --all --icons=always'

# ----------------------
# z --> (better cd)
# ----------------------
eval "$(zoxide init zsh)"
alias cd='z'

# ----------------------
# thefuck
# ----------------------
eval $(thefuck --alias)
eval $(thefuck --alias fk)

# Start fast fetch
fastfetch