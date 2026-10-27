# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal macOS dotfiles repo managed with GNU Stow. The repo root mirrors `$HOME` — every top-level dotfile/directory (`.zshrc`, `.config/`, etc.) gets symlinked directly into the user's home directory. There is no build step; "deploying" a change means stowing it.

## Commands

Recipes are defined in the `justfile`. The individual step recipes (`backup`, `xcode`, `homebrew`, `packages`, `zsh-plugins`, `dotfiles`) delegate into the corresponding function in `install.sh` (e.g. `INSTALL_SH_NO_MAIN=1 bash -c 'source install.sh && backup_configs'`) rather than reimplementing it — `install.sh` is the single source of truth for install logic. `INSTALL_SH_NO_MAIN=1` tells `install.sh`'s trailing guard to skip auto-running `main` when sourced; `test_install.sh` uses the same mechanism.

```bash
just                 # list all recipes
just install          # full fresh-machine setup: backup, xcode, homebrew, packages, zsh-plugins, dotfiles
just restow           # re-symlink after editing files in this repo (cd repo && stow --restow .)
just stow-dry          # preview what stow would change, without applying (stow --simulate --verbose .)
just update           # brew update && brew upgrade --formula && brew cleanup
```

Manual stow (no `just`):
```bash
stow .            # symlink everything into $HOME (run from repo root)
stow --restow .   # re-link after adding/removing files
stow -D .         # remove all symlinks created by stow
```

### Tests

`test_install.sh` unit-tests the functions in `install.sh` by sourcing it with `brew`/`git`/`stow`/`xcode-select`/`curl`/`sh` replaced with stub scripts on `$PATH`, so nothing is actually installed. Each case runs in a subshell with an isolated fake `$HOME`.

```bash
bash test_install.sh              # run the full suite
```

There's no way to run a single test case — the file is a flat sequence of subshelled assertions grouped by function (`backup_configs`, `install_xcode_tools`, `install_zsh_plugins`, `setup_dotfiles`). To isolate one, comment out the other subshell blocks or copy the relevant block into a scratch script.

When changing a function in `install.sh`, update the corresponding test block in `test_install.sh` in the same change — they test actual behavior (which files get backed up, which packages trigger installs) not just that the script runs.

## Architecture / how the pieces fit together

- **`install.sh`** is the canonical bootstrap script and the single source of truth for install logic (this is what the README's curl-pipe-to-bash quick start runs, and what `justfile`'s step recipes delegate into). It defines discrete functions (`backup_configs`, `install_xcode_tools`, `install_homebrew`, `install_packages`, `install_zsh_plugins`, `setup_dotfiles`) called in sequence from `main`, in dependency order (packages before zsh plugins/dotfiles, since those need `git`/`stow` from Homebrew). A trailing guard (`if [[ "${INSTALL_SH_NO_MAIN:-0}" != "1" ]]; then main; fi`) only auto-runs `main` when the script is executed directly (e.g. the curl-pipe invocation) — sourcing it with `INSTALL_SH_NO_MAIN=1` set (as `justfile` and `test_install.sh` do) loads the functions without running the full install. Written for bash 3.2 (macOS system bash) — avoid bash 4+ only features (e.g. no associative arrays; `test_install.sh` relies on parallel indexed arrays for the same reason). `install_packages` delegates the "already installed?" check for every formula/cask/optional package to a shared `brew_ensure_installed <pkg> [--cask|--optional]` helper rather than repeating the if/else per loop — add new packages by appending to the relevant array, not by writing new install logic.
- **`justfile`** exposes `install.sh`'s functions as individual recipes (`backup`, `xcode`, `homebrew`, `packages`, `zsh-plugins`, `dotfiles`) for users who already have `just`, plus maintenance recipes (`update`, `restow`, `stow-dry`) that `install.sh` doesn't need. Uses zsh with `-euo pipefail` as its shell. Each step recipe is a one-line parameterized dependency on a private `_run-step func` recipe (e.g. `backup: (_run-step "backup_configs")`) that holds the actual `INSTALL_SH_NO_MAIN=1 bash -c 'source install.sh && ...'` invocation — add a new step by adding a recipe of that same shape, not by repeating the `bash -c` line. Because the step recipes just source-and-call into `install.sh`, there's no install logic to keep in sync — changing behavior means editing `install.sh` only.
- **Stow determines what's "installed"**: any file/dir at the repo root becomes `~/<same-path>` via symlink. `.stow-local-ignore` excludes repo-only files (README, LICENSE, `.git*`, `install.sh`) from being symlinked. When adding a new config, just put it at the correct relative path under the repo root — no registration step needed.
- **`.zshrc`** loads Oh My Zsh with a curated plugin list (order matters: `fast-syntax-highlighting` must load last). Plugins are added conditionally based on what's actually installed (`command -v brew/jenv/mvn`) rather than unconditionally, to keep shell startup fast — follow that pattern for new tool integrations.
- **`.config/`** holds per-tool configs (aerospace, ghostty, borders, linearmouse, raycast, containers). Each subdirectory is independent; there's no shared structure to learn beyond "it's the tool's native config format in its native location." Note `~/.config` itself is a stow symlink to this directory (not per-subdirectory symlinks), so anything placed here is live in `$HOME` immediately — including tool-managed caches some apps write there at runtime (which is why `.config/.gitignore` excludes several subdirectories like `containers/`, `linearmouse/`, `raycast/` from version control even though they're physically present).
- **Backed-up files** (`backup_configs` in `install.sh`, called by `just backup`) are an explicit list of paths — `.zshrc`, `.config/aerospace`, `.config/ghostty`, `.config/starship.toml`, `.config/borders`. If you add a new stowed config that a fresh install would overwrite, add it to this one list in `install.sh`.
