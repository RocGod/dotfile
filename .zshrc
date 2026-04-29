# =============================================================================
# .zshrc — interactive zsh configuration
# Loaded for every interactive shell. Keep it fast; heavy work belongs elsewhere.
# =============================================================================

# -----------------------------------------------------------------------------
# Oh My Zsh framework settings (must be set BEFORE sourcing oh-my-zsh.sh)
# -----------------------------------------------------------------------------

# Auto-update Oh My Zsh without prompting.
zstyle ':omz:update' mode auto

# Suggest corrections for mistyped commands (e.g. `gti` → `git`).
ENABLE_CORRECTION="true"

# Add custom completion directory to fpath so compinit picks it up.
fpath=($HOME/.zsh-complete $fpath)

# Plugins to load. Order matters: zsh-syntax-highlighting MUST be last.
plugins=(
  starship                  # prompt integration
  brew                      # Homebrew completions
  fzf                       # fuzzy-finder key bindings (Ctrl-R, Ctrl-T, …)
  git                       # git aliases and completions
  jenv                      # Java version manager
  mvn                       # Maven completions
  nvm                       # Node version manager
  uv                        # uv (Python) completions
  zoxide                    # smarter `cd`
  zsh-autosuggestions       # ghost-text suggestions from history
  zsh-syntax-highlighting   # highlight commands as you type — keep last
)

# Source Oh My Zsh if it's installed.
export ZSH="$HOME/.oh-my-zsh"
if [ -d "$ZSH" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# -----------------------------------------------------------------------------
# History
# -----------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000                  # lines kept in memory
SAVEHIST=10000                  # lines persisted to disk

setopt HIST_IGNORE_ALL_DUPS     # drop older duplicate entries
setopt HIST_REDUCE_BLANKS       # trim superfluous whitespace
setopt INC_APPEND_HISTORY       # append immediately, not at shell exit
setopt SHARE_HISTORY            # share history across running shells

# -----------------------------------------------------------------------------
# Environment
# -----------------------------------------------------------------------------
export EDITOR="nvim"
export VISUAL="nvim"
export BAT_THEME=Nord

# Personal binaries take precedence over system ones.
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------

# Better defaults for common tools.
alias cat='bat'
alias cd='z'                                                   # zoxide
alias fzf="fzf --preview 'bat --color=always --line-range=:500 {}'"

# eza replaces ls with icons + long listing variants.
alias ls='eza -la --all --icons=always'
alias ll='eza -l --icons=always'
alias la='eza -la --icons=always'

# Safety nets — prompt before clobbering files.
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# -----------------------------------------------------------------------------
# Hooks / integrations
# -----------------------------------------------------------------------------

# Wrap `brew` so SketchyBar refreshes its package-update indicator after any
# command that could change the outdated count.
function brew() {
  command brew "$@"
  if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]]; then
    command -v sketchybar &>/dev/null && sketchybar --trigger brew_update
  fi
}

# Show a system-info banner, but only on login shells (not every new tab).
if [[ -o login ]] && command -v fastfetch &>/dev/null; then
  fastfetch
fi
