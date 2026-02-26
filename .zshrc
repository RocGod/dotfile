# ----------------------
# oh-my-zsh config
# ----------------------
zstyle ':omz:update' mode auto  
ENABLE_CORRECTION="true"

# Add custom completion path before compinit
fpath=($HOME/.zsh-complete $fpath)

# Enable command auto-correction and completion
autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit

# ----------------------
# History configuration
# ----------------------
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS    # Remove older duplicate entries from history
setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks from history items
setopt INC_APPEND_HISTORY      # Save history entries as soon as they are entered
setopt SHARE_HISTORY           # Share history between all sessions

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
# Only run fastfetch in login shells to avoid slowing down every new shell
if [[ -o login ]] && command -v fastfetch &>/dev/null; then
  fastfetch
fi

# ----------------------
# End of .zshrc
# ----------------------

