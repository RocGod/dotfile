# oh-my-zsh
zstyle ':omz:update' mode auto
ENABLE_CORRECTION="true"

# Custom completion path (must be set before oh-my-zsh sources compinit)
fpath=($HOME/.zsh-complete $fpath)

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

plugins=(
  starship
  brew
  fzf
  git
  jenv
  mvn
  nvm
  uv
  zoxide
  zsh-autosuggestions
  zsh-syntax-highlighting
)

export ZSH="$HOME/.oh-my-zsh"
if [ -d "$ZSH" ]; then
  source $ZSH/oh-my-zsh.sh
fi

# Environment
export EDITOR="nvim"
export VISUAL="nvim"
export BAT_THEME=Nord
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Notify sketchybar after brew updates
function brew() {
  command brew "$@"
  if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]]; then
    command -v sketchybar &>/dev/null && sketchybar --trigger brew_update
  fi
}

# Aliases
alias fzf="fzf --preview 'bat --color=always --line-range=:500 {}'"
alias cat='bat'
alias ls='eza -la --all --icons=always'
alias ll='eza -l --icons=always'
alias la='eza -la --icons=always'
alias cd='z'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# System info on login shells only
if [[ -o login ]] && command -v fastfetch &>/dev/null; then
  fastfetch
fi
