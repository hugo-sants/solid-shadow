#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUPS_DIR="$REPO_ROOT/.backups"

if [[ ! -d "$BACKUPS_DIR" ]]; then
    echo "Error: backup directory not found:"
    echo "  $BACKUPS_DIR"
    exit 1
fi

LATEST_BACKUP="$(
    find "$BACKUPS_DIR" \
        -mindepth 1 \
        -maxdepth 1 \
        -type d \
        -printf '%T@ %p\n' |
    sort -nr |
    head -1 |
    cut -d' ' -f2-
)"

if [[ -z "$LATEST_BACKUP" || ! -d "$LATEST_BACKUP" ]]; then
    echo "Error: no backup found."
    exit 1
fi

echo "Restoring backup:"
echo "  $LATEST_BACKUP"
echo

restore_file() {
    local source="$1"
    local destination="$2"

    if [[ -f "$source" ]]; then
        mkdir -p "$(dirname "$destination")"
        cp -a "$source" "$destination"
        echo "[RESTORE] $destination"
    fi
}

restore_dir() {
    local source="$1"
    local destination="$2"

    if [[ -d "$source" ]]; then
        mkdir -p "$destination"
        cp -a "$source/." "$destination/"
        echo "[RESTORE] $destination"
    fi
}

restore_dconf() {
    local source="$1"
    local dconf_path="$2"

    if [[ ! -f "$source" ]]; then
        return
    fi

    dconf load "$dconf_path" < "$source"
    echo "[RESTORE] dconf $dconf_path"
}

restore_file \
    "$LATEST_BACKUP/home/.zshrc" \
    "$HOME/.zshrc"

restore_file \
    "$LATEST_BACKUP/home/.p10k.zsh" \
    "$HOME/.p10k.zsh"

restore_dir \
    "$LATEST_BACKUP/config/zsh" \
    "$HOME/.config/zsh"

restore_dir \
    "$LATEST_BACKUP/config/nvim" \
    "$HOME/.config/nvim"

restore_dir \
    "$LATEST_BACKUP/config/lvim" \
    "$HOME/.config/lvim"

restore_dir \
    "$LATEST_BACKUP/config/gtk-3.0" \
    "$HOME/.config/gtk-3.0"

restore_dir \
    "$LATEST_BACKUP/config/gtk-4.0" \
    "$HOME/.config/gtk-4.0"

restore_dconf \
    "$LATEST_BACKUP/dconf/extensions.ini" \
    "/org/gnome/shell/extensions/"

restore_dconf \
    "$LATEST_BACKUP/dconf/ptyxis.ini" \
    "/org/gnome/Ptyxis/"

restore_dconf \
    "$LATEST_BACKUP/dconf/interface.ini" \
    "/org/gnome/desktop/interface/"

THEME_BACKUP="$LATEST_BACKUP/theme/settings.ini"

if [[ -f "$THEME_BACKUP" ]]; then
    gtk_theme="$(sed -n 's/^gtk-theme=//p' "$THEME_BACKUP")"
    icon_theme="$(sed -n 's/^icon-theme=//p' "$THEME_BACKUP")"
    cursor_theme="$(sed -n 's/^cursor-theme=//p' "$THEME_BACKUP")"
    cursor_size="$(sed -n 's/^cursor-size=//p' "$THEME_BACKUP")"

    [[ -n "$gtk_theme" ]] &&
        gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"

    [[ -n "$icon_theme" ]] &&
        gsettings set org.gnome.desktop.interface icon-theme "$icon_theme"

    [[ -n "$cursor_theme" ]] &&
        gsettings set org.gnome.desktop.interface cursor-theme "$cursor_theme"

    [[ -n "$cursor_size" ]] &&
        gsettings set org.gnome.desktop.interface cursor-size "$cursor_size"

    echo "[RESTORE] theme"
fi

echo
echo "Backup restored successfully."