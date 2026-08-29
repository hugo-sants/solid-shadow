#!/usr/bin/env bash

set -euo pipefail

EXTENSIONS=(
    "user-theme@gnome-shell-extensions.gcampax.github.com"
    "search-light@icedman.github.com"
    "gnome-ui-tune@itstime.tech"
    "just-perfection-desktop@just-perfection"
    "dash2dock-lite@icedman.github.com"
    "openbar@neuromorph"
    "clipboard-indicator@tudmotu.com"
    "quick-settings-avatar@d-go"
    "app-grid-tuner@m-lab"
    "gTile@vibou"
    "Vitals@CoreCoding.com"
    "blur-my-shell@aunetx"
    "dynamic-music-pill@andbal"
    "bluetooth-battery-monitor@v8v88v8v88.com"
    "background-logo@fedorahosted.org"
)

DOWNLOAD_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$DOWNLOAD_DIR"
}

trap cleanup EXIT

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Error: '$1' is required."
        exit 1
    fi
}

is_installed() {
    local uuid="$1"

    gnome-extensions list |
        grep -Fxq "$uuid"
}

get_shell_version() {
    gnome-shell --version |
        grep -oE '[0-9]+' |
        head -1
}

get_extension_versions() {
    local uuid="$1"

    curl -fsSL \
        "https://extensions.gnome.org/api/v1/extensions/${uuid}/versions/?page=1&page_size=100"
}

find_compatible_version() {
    local json="$1"
    local shell_version="$2"

    jq -r \
        --arg shell_version "$shell_version" '
        [
            .results[]
            | select(.status == 2 or .status == 3)
            | select(
                any(
                    .shell_versions[];
                    (.major | tostring) == $shell_version
                )
            )
            | .version
        ]
        | max // empty
        ' <<< "$json"
}

find_latest_version() {
    local json="$1"
    
    jq -r '
        [
            .results[]
            | select(.status == 2 or .status == 3)
            | .version
        ]
        | max // empty
        ' <<< "$json"
}

download_extension() {
    local uuid="$1"
    local version="$2"
    local output="$3"

    curl \
        --fail \
        --location \
        --silent \
        --show-error \
        -H 'Accept: application/zip' \
        -o "$output" \
        "https://extensions.gnome.org/api/v1/extensions/${uuid}/versions/${version}/?format=zip"
}

install_extension() {
    local uuid="$1"
    local shell_version="$2"

    local json
    local version
    local package_file

    if is_installed "$uuid"; then
        echo "[SKIP] $uuid already installed"
        return 0
    fi

    echo "[CHECK] $uuid"

    json="$(get_extension_versions "$uuid")"

    if [[ -z "$json" ]]; then
        echo "[FAIL] Could not retrieve extension information"
        return 1
    fi

    version="$(find_compatible_version "$json" "$shell_version")"

    if [[ -z "$version" ]]; then
        echo "[WARN] No officially compatible version found for GNOME $shell_version"
        echo "[FALLBACK] Using latest active version"

        version="$(find_latest_version "$json")"
    fi

    if [[ -z "$version" ]]; then
        echo "[FAIL] No downloadable version found for $uuid"
        return 1
    fi

    package_file="$DOWNLOAD_DIR/${uuid}.zip"

    echo "[DOWNLOAD] $uuid v$version"

    download_extension \
        "$uuid" \
        "$version" \
        "$package_file"

    echo "[INSTALL] $uuid v$version"

    gnome-extensions install \
        --force \
        "$package_file"

    echo "[OK] $uuid"
}

main() {
    require_command curl
    require_command jq
    require_command gnome-extensions
    require_command gnome-shell

    local shell_version

    shell_version="$(get_shell_version)"

    echo "GNOME Shell version: $shell_version"
    echo

    for uuid in "${EXTENSIONS[@]}"; do
        install_extension "$uuid" "$shell_version"
        echo
    done

    echo "Extension installation completed."
}

main "$@"