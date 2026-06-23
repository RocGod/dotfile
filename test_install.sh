#!/bin/bash
# =============================================================================
# test_install.sh — unit tests for install.sh functions
#
# Strategy: source install.sh with external commands mocked so nothing is
# actually installed. Each test case runs in its own subshell with an
# isolated fake $HOME (temp dir).
#
# Usage: bash test_install.sh
# =============================================================================

set -uo pipefail   # no -e here — we handle failures explicitly per assertion

# ── Colours ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ── Test counters (written to a tmp file so subshells can update them) ────────
RESULTS_FILE="$(mktemp)"
echo "0 0 0" > "$RESULTS_FILE"   # PASS FAIL SKIP

record() {
    local status="$1"
    read -r p f s < "$RESULTS_FILE"
    case "$status" in
        pass) ((p++)) ;;
        fail) ((f++)) ;;
        skip) ((s++)) ;;
    esac
    echo "$p $f $s" > "$RESULTS_FILE"
}

pass() { echo -e "${GREEN}  PASS${NC} $1"; record pass; }
fail() { echo -e "${RED}  FAIL${NC} $1"; record fail; }
skip() { echo -e "${YELLOW}  SKIP${NC} $1"; record skip; }

assert_eq() {
    local desc="$1" expected="$2" actual="$3"
    if [[ "$actual" == "$expected" ]]; then pass "$desc"
    else fail "$desc (expected: '$expected', got: '$actual')"; fi
}
assert_dir_exists()  { [[ -d "$2" ]]  && pass "$1" || fail "$1 (dir missing: $2)"; }
assert_dir_missing() { [[ ! -d "$2" ]] && pass "$1" || fail "$1 (dir still exists: $2)"; }
assert_file_exists() { [[ -e "$2" ]]  && pass "$1" || fail "$1 (file missing: $2)"; }
assert_contains()    { echo "$3" | grep -qF "$2" && pass "$1" || fail "$1 (expected '$2' in: $3)"; }
assert_not_contains(){ echo "$3" | grep -qF "$2" && fail "$1 (unexpected '$2' in output)" || pass "$1"; }

cleanup() { rm -rf "$RESULTS_FILE" "$FAKE_HOME" 2>/dev/null || true; }
trap cleanup EXIT

# ── Source helper: loads install.sh into current shell with:
#    • trap ERR disabled (we check return values explicitly in tests)
#    • `main` no-op'd so the trailing call doesn't run
# ─────────────────────────────────────────────────────────────────────────────
SOURCE_SCRIPT="$(sed \
    -e 's/^trap .*/: # trap disabled in tests/' \
    -e 's/^main$/: # main disabled in tests/' \
    install.sh)"

# ── Fake PATH: bin/ directory with stub executables ───────────────────────────
FAKE_BIN="$(mktemp -d)"
FAKE_HOME="$(mktemp -d)"

# brew stub: `brew list pkg` returns 1 (not installed) unless BREW_INSTALLED
# contains the pkg name. `brew install` and `brew tap` succeed silently.
cat > "$FAKE_BIN/brew" << 'STUB'
#!/bin/bash
if [[ "$1" == "list" ]]; then
    pkg="${*: -1}"
    echo "${BREW_INSTALLED:-}" | grep -qw "$pkg" && exit 0 || exit 1
fi
exit 0
STUB
chmod +x "$FAKE_BIN/brew"

# git stub: records clones into GIT_CLONES file if set
cat > "$FAKE_BIN/git" << 'STUB'
#!/bin/bash
if [[ "$1" == "clone" ]]; then
    dest="${@: -1}"
    mkdir -p "$dest"
    [[ -n "${GIT_CLONES:-}" ]] && echo "$dest" >> "$GIT_CLONES"
fi
exit 0
STUB
chmod +x "$FAKE_BIN/git"

# stow stub: records calls into STOW_CALLED file if set
cat > "$FAKE_BIN/stow" << 'STUB'
#!/bin/bash
[[ -n "${STOW_CALLED:-}" ]] && touch "$STOW_CALLED"
exit 0
STUB
chmod +x "$FAKE_BIN/stow"

# xcode-select stub: succeeds (already installed) unless XCODE_MISSING=1
cat > "$FAKE_BIN/xcode-select" << 'STUB'
#!/bin/bash
[[ "${XCODE_MISSING:-0}" == "1" && "$1" == "-p" ]] && exit 1
exit 0
STUB
chmod +x "$FAKE_BIN/xcode-select"

# curl stub: returns empty string
cat > "$FAKE_BIN/curl" << 'STUB'
#!/bin/bash
echo ""
STUB
chmod +x "$FAKE_BIN/curl"

# sh stub: no-op (used for OMZ install)
cat > "$FAKE_BIN/sh" << 'STUB'
#!/bin/bash
exit 0
STUB
chmod +x "$FAKE_BIN/sh"

export PATH="$FAKE_BIN:$PATH"

# =============================================================================
# TEST: backup_configs
# =============================================================================
echo ""
echo "── backup_configs ───────────────────────────────────────────────────────"

# Case 1: no config files → no backup dir created
(
    H="$(mktemp -d)"; trap "rm -rf $H" EXIT; export HOME="$H"
    eval "$SOURCE_SCRIPT"
    backup_configs
    count=$(find "$H" -name ".dotfiles_backup_*" -maxdepth 1 2>/dev/null | wc -l | tr -d ' ')
    assert_eq "no files exist → no backup dir" "0" "$count"
)

# Case 2: .zshrc exists → backup dir + file copied
(
    H="$(mktemp -d)"; trap "rm -rf $H" EXIT; export HOME="$H"
    touch "$H/.zshrc"
    eval "$SOURCE_SCRIPT"
    backup_configs
    bdir=$(find "$H" -name ".dotfiles_backup_*" -maxdepth 1 -type d | head -1)
    assert_dir_exists  ".zshrc exists → backup dir created"   "$bdir"
    assert_file_exists ".zshrc exists → file copied to backup" "$bdir/.zshrc"
)

# Case 3: .config/nvim exists → dir recursively copied
(
    H="$(mktemp -d)"; trap "rm -rf $H" EXIT; export HOME="$H"
    mkdir -p "$H/.config/nvim"
    eval "$SOURCE_SCRIPT"
    backup_configs
    bdir=$(find "$H" -name ".dotfiles_backup_*" -maxdepth 1 -type d | head -1)
    assert_dir_exists ".config/nvim → backed up recursively" "$bdir/nvim"
)

# Case 4: multiple files → all backed up
(
    H="$(mktemp -d)"; trap "rm -rf $H" EXIT; export HOME="$H"
    touch "$H/.zshrc"
    mkdir -p "$H/.config/ghostty"
    eval "$SOURCE_SCRIPT"
    backup_configs
    bdir=$(find "$H" -name ".dotfiles_backup_*" -maxdepth 1 -type d | head -1)
    assert_file_exists "multiple: .zshrc backed up"    "$bdir/.zshrc"
    assert_dir_exists  "multiple: ghostty dir backed up" "$bdir/ghostty"
)

# Case 5: only one backup dir created per run
(
    H="$(mktemp -d)"; trap "rm -rf $H" EXIT; export HOME="$H"
    touch "$H/.zshrc"
    eval "$SOURCE_SCRIPT"
    backup_configs
    count=$(find "$H" -name ".dotfiles_backup_*" -maxdepth 1 -type d | wc -l | tr -d ' ')
    assert_eq "only one backup dir per run" "1" "$count"
)

# =============================================================================
# TEST: install_xcode_tools
# =============================================================================
echo ""
echo "── install_xcode_tools ──────────────────────────────────────────────────"

# Case 1: already installed → log message, no --install
(
    H="$(mktemp -d)"; trap "rm -rf $H" EXIT; export HOME="$H"
    eval "$SOURCE_SCRIPT"
    out=$(install_xcode_tools 2>&1)
    assert_contains     "already installed: message shown"         "already installed" "$out"
    assert_not_contains "already installed: --install not invoked" "Installing Xcode"  "$out"
)

# Case 2: not installed, non-interactive → polls and waits
(
    H="$(mktemp -d)"; trap "rm -rf $H" EXIT; export HOME="$H"
    # Override xcode-select: first call to -p fails, second succeeds
    XCODE_MISSING=1
    # Write a custom stub that becomes available after first call
    call_n=0
    xcbin="$H/xcode-select"
    echo '#!/bin/bash
if [[ "$1" == "-p" ]]; then
    n_file="'"$H"'/xc_calls"
    count=$(cat "$n_file" 2>/dev/null || echo 0)
    echo $((count+1)) > "$n_file"
    [[ $(cat "$n_file") -ge 3 ]] && exit 0 || exit 1
fi
exit 0' > "$xcbin"
    chmod +x "$xcbin"
    export PATH="$H:$PATH"
    eval "$SOURCE_SCRIPT"
    out=$(install_xcode_tools </dev/null 2>&1 || true)
    assert_contains "not installed: triggers install log" "Installing Xcode"       "$out"
    assert_contains "not installed: shows waiting message" "Waiting for installation" "$out"
)

# =============================================================================
# TEST: install_zsh_plugins
# =============================================================================
echo ""
echo "── install_zsh_plugins ──────────────────────────────────────────────────"

# Case 1: OMZ and all plugins already present → git not called
(
    H="$(mktemp -d)"; trap "rm -rf $H" EXIT; export HOME="$H"
    mkdir -p "$H/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    mkdir -p "$H/.oh-my-zsh/custom/plugins/fast-syntax-highlighting"
    CLONES="$H/clones.txt"; touch "$CLONES"; export GIT_CLONES="$CLONES"
    eval "$SOURCE_SCRIPT"
    capture(){ "$@" 2>&1 || true; }
    capture install_zsh_plugins
    count=$(wc -l < "$CLONES" | tr -d ' ')
    assert_eq "all present: no git clones" "0" "$count"
)

# Case 2: plugins missing → both cloned
(
    H="$(mktemp -d)"; trap "rm -rf $H" EXIT; export HOME="$H"
    mkdir -p "$H/.oh-my-zsh/custom/plugins"
    CLONES="$H/clones.txt"; touch "$CLONES"; export GIT_CLONES="$CLONES"
    eval "$SOURCE_SCRIPT"
    install_zsh_plugins 2>&1 || true
    count=$(grep -c . "$CLONES" || echo 0)
    assert_eq "plugins missing: 2 clones made" "2" "$count"
)

# Case 3: conflicting zsh-syntax-highlighting → removed
(
    H="$(mktemp -d)"; trap "rm -rf $H" EXIT; export HOME="$H"
    mkdir -p "$H/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    mkdir -p "$H/.oh-my-zsh/custom/plugins/fast-syntax-highlighting"
    mkdir -p "$H/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    eval "$SOURCE_SCRIPT"
    install_zsh_plugins 2>&1 || true
    assert_dir_missing "conflicting plugin removed" \
        "$H/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
)

# Case 4: OMZ not installed → installer triggered
(
    H="$(mktemp -d)"; trap "rm -rf $H" EXIT; export HOME="$H"
    # No .oh-my-zsh dir at all → install should trigger
    eval "$SOURCE_SCRIPT"
    out=$(install_zsh_plugins 2>&1 || true)
    assert_contains "OMZ missing: log shown" "Installing Oh My Zsh" "$out"
)

# =============================================================================
# TEST: setup_dotfiles
# =============================================================================
echo ""
echo "── setup_dotfiles ───────────────────────────────────────────────────────"

# Case 1: dotfile dir exists → git not called, stow called
(
    H="$(mktemp -d)"; trap "rm -rf $H" EXIT; export HOME="$H"
    mkdir -p "$H/dotfile"
    CLONES="$H/clones.txt"; touch "$CLONES"; export GIT_CLONES="$CLONES"
    STOW_F="$H/stow_called";               export STOW_CALLED="$STOW_F"
    eval "$SOURCE_SCRIPT"
    setup_dotfiles 2>&1 || true
    clones=$(wc -l < "$CLONES" | tr -d ' ')
    assert_eq        "dir exists: no git clone"  "0"    "$clones"
    assert_file_exists "dir exists: stow called" "$STOW_F"
)

# Case 2: dotfile dir missing → git clone called
(
    H="$(mktemp -d)"; trap "rm -rf $H" EXIT; export HOME="$H"
    CLONES="$H/clones.txt"; touch "$CLONES"; export GIT_CLONES="$CLONES"
    STOW_F="$H/stow_called";               export STOW_CALLED="$STOW_F"
    eval "$SOURCE_SCRIPT"
    out=$(setup_dotfiles 2>&1 || true)
    assert_contains    "dir missing: clone triggered"  "Cloning dotfiles" "$out"
    assert_dir_exists  "dir missing: dir exists after" "$H/dotfile"
)

# Case 3: zsh cache dir created regardless
(
    H="$(mktemp -d)"; trap "rm -rf $H" EXIT; export HOME="$H"
    mkdir -p "$H/dotfile"
    eval "$SOURCE_SCRIPT"
    setup_dotfiles 2>&1 || true
    assert_dir_exists "zsh cache dir created" "$H/.zsh/cache"
)

# Case 4: cd inside setup_dotfiles does not leak to caller
(
    H="$(mktemp -d)"; trap "rm -rf $H" EXIT; export HOME="$H"
    mkdir -p "$H/dotfile"
    eval "$SOURCE_SCRIPT"
    before="$PWD"
    setup_dotfiles 2>&1 || true
    after="$PWD"
    assert_eq "cd does not leak to caller" "$before" "$after"
)

# =============================================================================
# Summary
# =============================================================================
echo ""
echo "═════════════════════════════════════════════════════════════════════════"
read -r PASS FAIL SKIP < "$RESULTS_FILE"
total=$((PASS + FAIL + SKIP))
echo -e "  Results: ${GREEN}${PASS} passed${NC}  ${RED}${FAIL} failed${NC}  ${YELLOW}${SKIP} skipped${NC}  (${total} total)"
echo "═════════════════════════════════════════════════════════════════════════"
echo ""

[[ $FAIL -eq 0 ]]
