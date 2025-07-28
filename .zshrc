# ----------------------
# oh-my-posh config
# ----------------------
# Enable ohmyposh instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/base.json)"
# if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
#   eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/base.json)"
# fi

# ----------------------
# oh-my-zsh config
# ----------------------
zstyle ':omz:update' mode auto  
ENABLE_CORRECTION="true"

# Enable command auto-correction and completion
autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit

plugins=(
  starship
  brew
  fzf
  git
  jenv
  mvn
  nvm
  thefuck
  tmux
  uv
  zoxide
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
if [ -d "$ZSH" ]; then
  source $ZSH/oh-my-zsh.sh
fi

# ----------------------
# Environment variables
# ----------------------
export EDITOR="nvim"
export VISUAL="nvim"
export BAT_THEME=Nord

# ----------------------
# PATH modifications
# ----------------------
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# ----------------------
# Sketchybar interactivity overloads
# ----------------------
function brew() {
  command brew "$@" 
  if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]]; then
    command -v sketchybar &>/dev/null && sketchybar --trigger brew_update
  fi
}

# -----------------------------
# Bat (better cat)
# -----------------------------
alias fzf="fzf --preview 'bat --color=always --line-range=:500 {}'"
alias cat='bat'

# ----------------------
# eza (better ls)
# ----------------------
alias ls='eza -la --all --icons=always'
alias ll='eza -l --icons=always'
alias la='eza -la --icons=always'

# ----------------------
# z (better cd)
# ----------------------
alias cd='z'

# ----------------------
# Safety aliases
# ----------------------
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ----------------------
# Fastfetch (system info)
# ----------------------
command -v fastfetch &>/dev/null && fastfetch

# ----------------------
# End of .zshrc
# ----------------------

