# Dotfiles for macOS

This repository contains my personal configuration files and scripts for quickly setting up a new macOS machine.

---

## 📚 Table of Contents

- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [What's Included](#-whats-included)
- [Post-Install Manual Steps](#-post-install-manual-steps)
- [Updating & Uninstalling](#-updating--uninstalling)
- [Structure](#%EF%B8%8F-structure)
- [Acknowledgements](#-acknowledgements)
- [License](#-license)

---

## ✅ Prerequisites

- macOS 13 (Ventura) or later — tested on Apple Silicon
- Internet connection
- An Apple ID signed in (required for App Store / Xcode CLT)
- `git` and `stow` available before running the installer (Xcode CLT provides `git`; `stow` is installed via Homebrew during setup, so the very first run still requires manually running `brew install stow` before the final `stow .` step if you choose to bootstrap manually)

> ⚠️ **Always review remote scripts before piping them to your shell.** Open [`install.sh`](./install.sh) and read it before running the Quick Start command below.

---

## 🚀 Quick Start

> ⚠️ **Review the script before running.** Read [`install.sh`](./install.sh) first — never pipe a remote script into `bash` blindly.

To set up your new Mac with all required packages and configurations, run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/RocGod/dotfile/main/install.sh)"
```

The `install.sh` script will:

1. Back up existing configs to `~/.dotfiles_backup_<timestamp>`
2. Install Xcode Command Line Tools and Homebrew
3. Install Oh My Zsh + plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`)
4. Install all CLI, development, and window-management packages via Homebrew
5. Clone this repo to `~/dotfile` and symlink everything with `stow`

---

## 📦 What's Included

- **Shell & Prompt:** [Oh My Zsh](https://ohmyz.sh/) with `zsh-autosuggestions` and `zsh-syntax-highlighting`, [Starship](https://starship.rs/) prompt, [Nushell](https://www.nushell.sh/) config
- **CLI Tools:** [`bat`](https://github.com/sharkdp/bat), [`eza`](https://github.com/eza-community/eza), [`zoxide`](https://github.com/ajeetdsouza/zoxide), [`fzf`](https://github.com/junegunn/fzf), [`yazi`](https://github.com/sxyazi/yazi), [`fastfetch`](https://github.com/fastfetch-cli/fastfetch), `tmux`
- **Terminals:** [Ghostty](https://ghostty.org/), [Kitty](https://sw.kovidgoyal.net/kitty/), [WezTerm](https://wezfurlong.org/wezterm/) (`.wezterm.lua`)
- **Development:** `git` (+ `jgit`), `jenv`, `mvnvm`, `nvm`, `uv`
- **Window Management & Desktop:** [yabai](https://github.com/koekeishiya/yabai), [skhd](https://github.com/koekeishiya/skhd), [Aerospace](https://github.com/nikitabobko/AeroSpace), [SketchyBar](https://github.com/FelixKratz/SketchyBar), [JankyBorders](https://github.com/FelixKratz/JankyBorders), [LinearMouse](https://linearmouse.app/), [Raycast](https://www.raycast.com/)
- **Editor:** [Neovim](https://neovim.io/) — custom config in `.config/nvim`
- **Fonts:** JetBrains Mono Nerd Font

---

## 🛠 Post-Install Manual Steps

A few things `install.sh` cannot automate — handle these after the script finishes:

1. **Grant accessibility permissions** to `yabai`, `skhd`, and Raycast in *System Settings → Privacy & Security → Accessibility*.
2. **Disable SIP partially** if you want yabai's scripting addition (see the [yabai wiki](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection)).
3. **Start the services**:
   ```bash
   yabai --start-service
   skhd  --start-service
   brew services start sketchybar
   brew services start borders
   ```
4. **Neovim**: open `nvim` and run `:Lazy sync` (or `:checkhealth`) to install plugins.
5. **tmux**: press `prefix + I` to install plugins via TPM if used.
6. **Raycast**: sign in and import settings if you sync them.
7. **Set your default shell** to the Homebrew zsh if desired:
   ```bash
   chsh -s /opt/homebrew/bin/zsh
   ```

---

## 🔄 Updating & Uninstalling

Pull the latest configs and re-link:

```bash
cd ~/dotfile
git pull
stow --restow .
```

Remove all symlinks created by stow:

```bash
cd ~/dotfile
stow -D .
```

Restore a backup created by `install.sh`:

```bash
ls ~/.dotfiles_backup_*
# then copy what you need back into place
```

---

## �️ Structure

**Root files**

| Path | Purpose |
| --- | --- |
| `.zshrc` | Zsh shell config (Oh My Zsh, plugins, aliases) |
| `.tmux.conf` | tmux key bindings and theme |
| `.wezterm.lua` | WezTerm terminal config |
| `.stow-local-ignore` | Files stow should skip when symlinking |
| `install.sh` | Bootstrap script for a fresh Mac |

**`.config/` — grouped by purpose**

| Directory | Purpose |
| --- | --- |
| **Shell / prompt** | |
| `nushell/` | Nushell shell config |
| `starship.toml` | Starship prompt theme |
| **Terminals** | |
| `ghostty/` | Ghostty terminal config |
| `kitty/` | Kitty terminal config |
| **Editor** | |
| `nvim/` | Neovim config (lazy.nvim plugins, LSP, etc.) |
| **Window management & desktop** | |
| `yabai/` | yabai tiling WM rules |
| `skhd/` | skhd hotkey daemon |
| `aerospace/` | AeroSpace tiling WM (alternative to yabai) |
| `sketchybar/` | SketchyBar status bar |
| `borders/` | JankyBorders window-border config |
| `linearmouse/` | LinearMouse settings |
| `raycast/` | Raycast launcher settings |
| **File management** | |
| `yazi/` | yazi terminal file manager |
| **Development** | |
| `jgit/` | Shared git config / hooks |
| **Misc** | |
| `configstore/` | App config-store data |
| `containers/` | Container runtime config |

---

## 🙏 Acknowledgements

- **yabai & skhd** — see the [yabai](https://github.com/koekeishiya/yabai) and [skhd](https://github.com/koekeishiya/skhd) docs for setup and required permissions. My config is based on [this tutorial](https://www.josean.com/posts/yabai-setup) by [@josean-dev](https://github.com/josean-dev).
- **SketchyBar & JankyBorders** — see [SketchyBar](https://github.com/FelixKratz/SketchyBar) and [JankyBorders](https://github.com/FelixKratz/JankyBorders). My sketchybar config is inspired by [@FelixKratz](https://github.com/FelixKratz) and [@hbthen3rd](https://github.com/hbthen3rd).

---

## 📝 License

Personal use only. Feel free to fork and adapt for your own setup.
