#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TIMESTAMP="$(date '+%Y-%m-%d_%H-%M-%S')"
BACKUP_DIR="$REPO_ROOT/.backups/$TIMESTAMP"

mkdir -p "$BACKUP_DIR"

echo "Creating backup..."
echo "Location: $BACKUP_DIR"
echo

backup_file() {
    local source="$1"
    local destination="$2"

    if [[ -f "$source" ]]; then
        mkdir -p "$(dirname "$destination")"
        cp -a "$source" "$destination"
        echo "[BACKUP] $source"
    fi
}

backup_dir() {
    local source="$1"
    local destination="$2"

    if [[ -d "$source" ]]; then
        mkdir -p "$destination"
        cp -a "$source/." "$destination/"
        echo "[BACKUP] $source"
    fi
}

backup_dconf() {
    local dconf_path="$1"
    local destination="$2"

    if ! command -v dconf >/dev/null 2>&1; then
        echo "[SKIP] dconf is not installed"
        return
    fi

    local content
    content="$(dconf dump "$dconf_path" 2>/dev/null || true)"

    if [[ -n "$content" ]]; then
        mkdir -p "$(dirname "$destination")"
        printf '%s\n' "$content" > "$destination"
        echo "[BACKUP] dconf $dconf_path"
    fi
}

backup_file \
    "$HOME/.zshrc" \
    "$BACKUP_DIR/home/.zshrc"

backup_file \
    "$HOME/.p10k.zsh" \
    "$BACKUP_DIR/home/.p10k.zsh"

backup_dir \
    "$HOME/.config/zsh" \
    "$BACKUP_DIR/config/zsh"

backup_dir \
    "$HOME/.config/nvim" \
    "$BACKUP_DIR/config/nvim"

backup_dir \
    "$HOME/.config/lvim" \
    "$BACKUP_DIR/config/lvim"

backup_dir \
    "$HOME/.config/gtk-3.0" \
    "$BACKUP_DIR/config/gtk-3.0"

backup_dir \
    "$HOME/.config/gtk-4.0" \
    "$BACKUP_DIR/config/gtk-4.0"

backup_dconf \
    "/org/gnome/shell/extensions/" \
    "$BACKUP_DIR/dconf/extensions.ini"

backup_dconf \
    "/org/gnome/Ptyxis/" \
    "$BACKUP_DIR/dconf/ptyxis.ini"

backup_dconf \
    "/org/gnome/desktop/interface/" \
    "$BACKUP_DIR/dconf/interface.ini"

mkdir -p "$BACKUP_DIR/theme"

{
    printf '[theme]\n'
    printf 'gtk-theme=%s\n' \
        "$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | tr -d "'")"
    printf 'icon-theme=%s\n' \
        "$(gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null | tr -d "'")"
    printf 'cursor-theme=%s\n' \
        "$(gsettings get org.gnome.desktop.interface cursor-theme 2>/dev/null | tr -d "'")"
    printf 'cursor-size=%s\n' \
        "$(gsettings get org.gnome.desktop.interface cursor-size 2>/dev/null)"
} > "$BACKUP_DIR/theme/settings.ini"

cat > "$BACKUP_DIR/metadata.txt" <<EOF
Backup created: $(date '+%Y-%m-%d %H:%M:%S %Z')
Hostname: $(hostname)
User: $USER
Home: $HOME
Repository: $REPO_ROOT
EOF

echo
echo "Backup completed successfully."
echo "Saved to:"
echo "  $BACKUP_DIR"