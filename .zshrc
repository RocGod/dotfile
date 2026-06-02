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

# -----------------------------------------------------------------------------
# Performance flags (set BEFORE sourcing oh-my-zsh.sh)
# -----------------------------------------------------------------------------

# Skip per-prompt widget rebinding in zsh-autosuggestions.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Disable URL-quoting magic functions (slow on every keypress).
DISABLE_MAGIC_FUNCTIONS=true

# Skip insecure-directory checks in compinit (saves a directory scan).
DISABLE_COMPFIX=true

# Enable completion caching for faster tab completion.
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Add custom completion directory to fpath so compinit picks it up.
fpath=($HOME/.zsh-complete $fpath)

# Plugins to load. Order matters: syntax highlighting MUST be last.
# Only load plugins for tools that are actually installed.
plugins=(
  starship                  # prompt integration
  fzf                       # fuzzy-finder key bindings (Ctrl-R, Ctrl-T, …)
  git                       # git aliases and completions
  uv                        # uv (Python) completions
  zoxide                    # smarter `cd`
  zsh-autosuggestions       # ghost-text suggestions from history
  fast-syntax-highlighting  # highlight commands as you type — keep last
)

# Conditionally add plugins only if their tools are installed.
command -v brew &>/dev/null && plugins+=(brew)
command -v jenv &>/dev/null && plugins+=(jenv)
command -v mvn &>/dev/null && plugins+=(mvn)

# Source Oh My Zsh if it's installed.
export ZSH="$HOME/.oh-my-zsh"
if [ -d "$ZSH" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# -----------------------------------------------------------------------------
# History
# -----------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=50000                  # lines kept in memory (increased for better recall)
SAVEHIST=50000                  # lines persisted to disk

setopt HIST_IGNORE_ALL_DUPS     # drop older duplicate entries
setopt HIST_FIND_NO_DUPS        # don't show duplicates when searching
setopt HIST_EXPIRE_DUPS_FIRST   # expire duplicates first when trimming history
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
# Directory Navigation
# -----------------------------------------------------------------------------
setopt AUTO_PUSHD               # automatically push directories onto stack
setopt PUSHD_IGNORE_DUPS        # don't push duplicate directories
setopt PUSHD_SILENT             # don't print directory stack after pushd/popd

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------

# Better defaults for common tools.
alias cat='bat'
alias cd='z'                                                   # zoxide
alias fzf="fzf --preview 'bat --color=always --line-range=:500 {}'"

# Enhanced fzf configuration with better defaults.
export FZF_DEFAULT_OPTS="
  --height 40%
  --layout=reverse
  --border
  --inline-info
  --color=fg:#e5e9f0,bg:#2e3440,hl:#81a1c1
  --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1
  --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
  --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b
"

# Use fd for fzf if available (faster than find).
if command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# eza replaces ls with icons + long listing variants.
alias ls='eza -la --all --icons=always'
alias ll='eza -l --icons=always'
alias la='eza -la --icons=always'

# Safety nets — prompt before clobbering files.
# Note: These can be bypassed with \rm, \cp, \mv. Consider using trash-cli for safer deletion.
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# If trash-cli is installed, provide a safer alternative to rm.
if command -v trash-put &>/dev/null; then
  alias trash='trash-put'
fi

# Homebrew maintenance helper. `brew outdated` can return 1 when nothing is
# outdated, so avoid short-circuiting before upgrade.
unalias bubu 2>/dev/null
function bubu() {
  brew update || true
  brew outdated || true
  brew upgrade
}

# -----------------------------------------------------------------------------
# Hooks / integrations
# -----------------------------------------------------------------------------

# fnm — fast Rust-based Node version manager (replaces nvm, near-instant init).
if command -v fnm &>/dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)" 2>/dev/null || echo "Warning: fnm initialization failed"
fi

# Show a system-info banner, but only on login shells (not every new tab).
if [[ -o login ]] && command -v fastfetch &>/dev/null; then
  fastfetch
fi
