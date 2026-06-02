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
- Nothing else — the installer handles `git` (via Xcode CLT) and `stow` (via Homebrew) for you

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
3. Install Oh My Zsh + plugins (`zsh-autosuggestions`, `fast-syntax-highlighting`)
4. Install all CLI, development, and window-management packages via Homebrew
5. Clone this repo to `~/dotfile` and symlink everything with `stow`
6. Create zsh cache directory for completion caching

---

## 📦 What's Included

### Core Tools
- **Shell & Prompt:** [Oh My Zsh](https://ohmyz.sh/) with `zsh-autosuggestions` and `fast-syntax-highlighting`, [Starship](https://starship.rs/) prompt
- **CLI Tools:** [`bat`](https://github.com/sharkdp/bat), [`eza`](https://github.com/eza-community/eza), [`zoxide`](https://github.com/ajeetdsouza/zoxide), [`fzf`](https://github.com/junegunn/fzf), [`fd`](https://github.com/sharkdp/fd), [`fastfetch`](https://github.com/fastfetch-cli/fastfetch), `tmux`
- **Development:** `git`, `jenv`, `mvnvm`, [`fnm`](https://github.com/Schniz/fnm) (fast Node version manager), [`uv`](https://github.com/astral-sh/uv) (Python package manager)
- **Window Management:** [SketchyBar](https://github.com/FelixKratz/SketchyBar), [JankyBorders](https://github.com/FelixKratz/JankyBorders)
- **Fonts:** JetBrains Mono Nerd Font

### Optional Tools (installed if available)
- [`trash-cli`](https://github.com/andreafrancia/trash-cli) — safer alternative to `rm`
- [`ripgrep`](https://github.com/BurntSushi/ripgrep) — faster grep (`rg`)
- [Neovim](https://neovim.io/) — modern vim editor

### Shell Features
- **Performance optimizations:** Completion caching, conditional plugin loading, 50K history entries
- **Enhanced fzf:** Nord color scheme, `fd` integration for faster file searching
- **Smart navigation:** Auto-pushd with duplicate prevention
- **Safety features:** Interactive prompts for `rm`/`cp`/`mv`, `trash-cli` integration

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
4. **Neovim** (if installed): open `nvim` and run `:Lazy sync` or `:checkhealth` to install plugins.
5. **tmux**: press `prefix + I` to install plugins via TPM if used.
6. **Set your default shell** to the Homebrew zsh if desired:
   ```bash
   chsh -s /opt/homebrew/bin/zsh
   ```
7. **Verify installation**: Run `source ~/.zshrc` to load the new configuration.

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

## 🗂️ Structure

**Root files**

| Path | Purpose |
| --- | --- |
| `.zshrc` | Zsh shell config with performance optimizations, plugins, and aliases |
| `.tmux.conf` | tmux key bindings and theme |
| `.stow-local-ignore` | Files stow should skip when symlinking |
| `install.sh` | Bootstrap script for a fresh Mac (simplified and optimized) |

**`.config/` — grouped by purpose**

| Directory | Purpose |
| --- | --- |
| **Shell / prompt** | |
| `starship.toml` | Starship prompt theme |
| **Window management & desktop** | |
| `yabai/` | yabai tiling WM rules |
| `skhd/` | skhd hotkey daemon |
| `sketchybar/` | SketchyBar status bar |
| `borders/` | JankyBorders window-border config |

### Key Configuration Highlights

**`.zshrc` features:**
- Completion caching for faster tab completion
- Conditional plugin loading (only loads plugins for installed tools)
- 50,000 history entries with smart duplicate handling
- Enhanced fzf with Nord color scheme and `fd` integration
- Auto-pushd for better directory navigation
- Safety aliases with `trash-cli` integration
- Fast Node.js version management with `fnm`

**`install.sh` features:**
- Automatic backup of existing configs
- Simplified code with bash best practices
- Conditional installation of optional packages
- Automatic removal of conflicting plugins
- Creates necessary cache directories

---

## 🙏 Acknowledgements

- **yabai & skhd** — see the [yabai](https://github.com/koekeishiya/yabai) and [skhd](https://github.com/koekeishiya/skhd) docs for setup and required permissions. My config is based on [this tutorial](https://www.josean.com/posts/yabai-setup) by [@josean-dev](https://github.com/josean-dev).
- **SketchyBar & JankyBorders** — see [SketchyBar](https://github.com/FelixKratz/SketchyBar) and [JankyBorders](https://github.com/FelixKratz/JankyBorders). My sketchybar config is inspired by [@FelixKratz](https://github.com/FelixKratz) and [@hbthen3rd](https://github.com/hbthen3rd).

---

## 📝 License

Personal use only. Feel free to fork and adapt for your own setup.
