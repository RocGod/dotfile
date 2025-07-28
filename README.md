# Dotfiles for macOS

This repository contains my personal configuration files and scripts for quickly setting up a new macOS machine.

---

## 🚀 Quick Start

To set up your new Mac with all required packages and configurations, run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/RocGod/dotfile/main/install.sh)"
```

---

## 📦 What’s Included

- **Shell:** [Oh My Zsh](https://ohmyz.sh/), plugins, and custom aliases
- **Terminal Tools:** `bat`, `eza`, `fzf`, `starship`, `tmux`, `zoxide`, and more
- **Development:** `git`, `jenv`, `nvm`, `mvn`, `uv`
- **Window Management:** [yabai](https://github.com/koekeishiya/yabai), [skhd](https://github.com/koekeishiya/skhd), [sketchybar](https://github.com/FelixKratz/SketchyBar), [borders](https://github.com/FelixKratz/JankyBorders)
- **Fonts:** JetBrains Mono Nerd Font
- **Neovim:** Custom configuration in `.config/nvim`

---

## ⚠️ Notes & References

### Yabai & skhd

- Please refer to the [yabai documentation](https://github.com/koekeishiya/yabai) and [skhd documentation](https://github.com/koekeishiya/skhd) for installation steps and permissions.
- My yabai config is based on [this tutorial](https://www.josean.com/posts/yabai-setup) by [@josean-dev](https://github.com/josean-dev).

### Sketchybar & Borders

- See [sketchybar](https://github.com/FelixKratz/SketchyBar) and [borders](https://github.com/FelixKratz/JankyBorders) for installation and usage.
- My sketchybar config is inspired by [@FelixKratz](https://github.com/FelixKratz) and [@hbthen3rd](https://github.com/hbthen3rd).

---

## 🗂️ Structure

```
.
├── .zshrc
├── .tmux.conf
├── install.sh
├── .config/
│   ├── nvim/
│   ├── yabai/
│   └── skhd/
└── ...
```

---

## 🙏 Credits

- [@josean-dev](https://github.com/josean-dev) for the yabai setup guide
- [@FelixKratz](https://github.com/FelixKratz) and [@hbthen3rd](https://github.com/hbthen3rd) for sketchybar and borders configs

---

## 📝 License

Personal use only. Feel free to fork and adapt for your own
