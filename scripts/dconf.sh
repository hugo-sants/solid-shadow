#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

EXTENSIONS_DIR="$REPO_ROOT/gnome/dconf/extensions"

apply_extensions() {
    declare -A dconf_paths=(
        ["user-theme@gnome-shell-extensions.gcampax.github.com"]="user-theme"
        ["search-light@icedman.github.com"]="search-light"
        ["gnome-ui-tune@itstime.tech"]="gnome-ui-tune"
        ["just-perfection-desktop@just-perfection"]="just-perfection"
        ["dash2dock-lite@icedman.github.com"]="dash2dock-lite"
        ["openbar@neuromorph"]="openbar"
        ["clipboard-indicator@tudmotu.com"]="clipboard-indicator"
        ["quick-settings-avatar@d-go"]="quick-settings-avatar"
        ["app-grid-tuner@m-lab"]="app-grid-tuner"
        ["gTile@vibou"]="gtile"
        ["Vitals@CoreCoding.com"]="vitals"
        ["blur-my-shell@aunetx"]="blur-my-shell"
        ["dynamic-music-pill@andbal"]="dynamic-music-pill"
        ["pop-shell@system76.com"]="pop-shell"
        ["bluetooth-battery-monitor@v8v88v8v88.com"]="bluetooth-battery-monitor"
        ["rainclock@hugo-sants.github.com"]="rainclock"
        ["background-logo@fedorahosted.org"]="background-logo"
    )

    if ! command -v dconf >/dev/null 2>&1; then
        echo "Error: dconf is not installed."
        exit 1
    fi

    if [[ ! -d "$EXTENSIONS_DIR" ]]; then
        echo "Error: extension configuration directory not found:"
        echo "  $EXTENSIONS_DIR"
        exit 1
    fi

    for uuid in "${!dconf_paths[@]}"; do
        config="$EXTENSIONS_DIR/$uuid/config.ini"
        dconf_name="${dconf_paths[$uuid]}"
        dconf_path="/org/gnome/shell/extensions/$dconf_name/"

        if [[ ! -f "$config" ]]; then
            echo "[SKIP] $uuid"
            continue
        fi

        echo "[APPLY] $uuid"

        dconf load "$dconf_path" < "$config"
    done
}

apply_all() {
    echo "Optional full DConf restore is not enabled yet."
    echo "Use:"
    echo "  $0 extensions"
}

case "${1:-extensions}" in
    extensions)
        apply_extensions
        ;;
    all)
        apply_all
        ;;
    *)
        echo "Usage: $0 [extensions|all]"
        exit 1
        ;;
esac