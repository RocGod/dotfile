# =============================================================================
# .zshrc — interactive zsh configuration
# Loaded for every interactive shell. Keep it fast; heavy work belongs elsewhere.
# =============================================================================

# -----------------------------------------------------------------------------
# Environment & PATH (set early so tools & plugins are available)
# -----------------------------------------------------------------------------
export EDITOR="vim"
export VISUAL="vim"
export BAT_THEME=Nord
export HOMEBREW_NO_UPGRADE_AUTO_UPDATES_CASKS=1

# Zerobrew setup
export ZEROBREW_ROOT='/opt/zerobrew'
export ZEROBREW_PREFIX='/opt/zerobrew'
export PKG_CONFIG_PATH="$ZEROBREW_PREFIX/lib/pkgconfig:${PKG_CONFIG_PATH:-}"

# SSL/TLS certificates (only if ca-certificates is installed)
if [ -z "${CURL_CA_BUNDLE:-}" ] || [ -z "${SSL_CERT_FILE:-}" ]; then
  if [ -f "$ZEROBREW_PREFIX/opt/ca-certificates/share/ca-certificates/cacert.pem" ]; then
    [ -z "${CURL_CA_BUNDLE:-}" ] && export CURL_CA_BUNDLE="$ZEROBREW_PREFIX/opt/ca-certificates/share/ca-certificates/cacert.pem"
    [ -z "${SSL_CERT_FILE:-}" ] && export SSL_CERT_FILE="$ZEROBREW_PREFIX/opt/ca-certificates/share/ca-certificates/cacert.pem"
  elif [ -f "$ZEROBREW_PREFIX/etc/ca-certificates/cacert.pem" ]; then
    [ -z "${CURL_CA_BUNDLE:-}" ] && export CURL_CA_BUNDLE="$ZEROBREW_PREFIX/etc/ca-certificates/cacert.pem"
    [ -z "${SSL_CERT_FILE:-}" ] && export SSL_CERT_FILE="$ZEROBREW_PREFIX/etc/ca-certificates/cacert.pem"
  elif [ -f "$ZEROBREW_PREFIX/etc/openssl/cert.pem" ]; then
    [ -z "${CURL_CA_BUNDLE:-}" ] && export CURL_CA_BUNDLE="$ZEROBREW_PREFIX/etc/openssl/cert.pem"
    [ -z "${SSL_CERT_FILE:-}" ] && export SSL_CERT_FILE="$ZEROBREW_PREFIX/etc/openssl/cert.pem"
  elif [ -f "$ZEROBREW_PREFIX/share/ca-certificates/cacert.pem" ]; then
    [ -z "${CURL_CA_BUNDLE:-}" ] && export CURL_CA_BUNDLE="$ZEROBREW_PREFIX/share/ca-certificates/cacert.pem"
    [ -z "${SSL_CERT_FILE:-}" ] && export SSL_CERT_FILE="$ZEROBREW_PREFIX/share/ca-certificates/cacert.pem"
  fi
fi

if [ -z "${SSL_CERT_DIR:-}" ]; then
  if [ -d "$ZEROBREW_PREFIX/etc/ca-certificates" ]; then
    export SSL_CERT_DIR="$ZEROBREW_PREFIX/etc/ca-certificates"
  elif [ -d "$ZEROBREW_PREFIX/etc/openssl/certs" ]; then
    export SSL_CERT_DIR="$ZEROBREW_PREFIX/etc/openssl/certs"
  elif [ -d "$ZEROBREW_PREFIX/share/ca-certificates" ]; then
    export SSL_CERT_DIR="$ZEROBREW_PREFIX/share/ca-certificates"
  fi
fi

# Bun
export BUN_INSTALL="$HOME/.bun"

# Ensure binaries take precedence: Local > Bun > Zerobrew > Homebrew > System
export PATH="$HOME/.local/bin:$BUN_INSTALL/bin:$ZEROBREW_PREFIX/bin:$ZEROBREW_PREFIX/sbin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
typeset -U path PATH

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

# Add completion directories to fpath so compinit picks them up.
fpath=(
  $HOME/.zsh-complete
  /opt/zerobrew/share/zsh/site-functions
  /opt/homebrew/share/zsh/site-functions
  $fpath
)
typeset -U fpath

# Plugins to load. Order matters: syntax highlighting MUST be last.
# Only load plugins for tools that are actually installed.
plugins=(
  starship                  # prompt integration
  fzf                       # fuzzy-finder key bindings (Ctrl-R, Ctrl-T, …)
  git                       # git aliases and completions
  uv                        # uv (Python) completions
  zoxide                    # smarter `cd`
  zsh-autosuggestions       # ghost-text suggestions from history
  direnv                    # auto-load per-directory env vars from .envrc
  sdk                       # sdkman tab-completion
  fast-syntax-highlighting  # highlight commands as you type — keep last
)

# Conditionally add plugins only if their tools are installed.
command -v brew &>/dev/null && plugins+=(brew)
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
setopt HIST_IGNORE_SPACE        # don't record commands prefixed with a space
setopt EXTENDED_HISTORY         # store a timestamp with each history entry
setopt SHARE_HISTORY            # share history across running shells (implies incremental append)


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
alias ctx='context-mode'                                       # context-mode CLI
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

# Package maintenance helper (updates Zerobrew and Homebrew).
function bubu() {
  if command -v zb &>/dev/null; then
    zb update || true
    zb outdated || true
    zb upgrade
  fi
  if command -v brew &>/dev/null; then
    brew update || true
    brew outdated --formula || true
    brew upgrade --formula
  fi
}

# -----------------------------------------------------------------------------
# Hooks / integrations
# -----------------------------------------------------------------------------

# fnm — fast Rust-based Node version manager (replaces nvm, near-instant init).
if command -v fnm &>/dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)" 2>/dev/null || echo "Warning: fnm initialization failed"
fi

# OrbStack — needed for non-login shells (most terminal tabs skip ~/.zprofile).
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Show a system-info banner, but only on login shells (not every new tab).
if [[ -o login ]] && command -v fastfetch &>/dev/null; then
  fastfetch
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# >>> adp >>>
# Written by `adp setup`; this block is replaced on every run. Edit outside it.
case "$PATH:" in "$HOME/.local/bin:"*) ;; *) export PATH="$HOME/.local/bin:$PATH" ;; esac
alias adp-claude='adp start'
# <<< adp <<<
