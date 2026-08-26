#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGE_FILE="$REPO_ROOT/flatpak.txt"

if ! command -v flatpak >/dev/null 2>&1; then
    echo "Error: Flatpak is required."
    exit 1
fi

if [[ ! -f "$PACKAGE_FILE" ]]; then
    echo "Error: flatpak.txt not found:"
    echo "  $PACKAGE_FILE"
    exit 1
fi

mapfile -t packages < <(
    grep -vE '^[[:space:]]*(#|$)' "$PACKAGE_FILE"
)

if [[ "${#packages[@]}" -eq 0 ]]; then
    echo "No Flatpak packages found."
    exit 0
fi

echo "Installing Flatpak applications from Flathub:"
printf '  %s\n' "${packages[@]}"
echo

flatpak install -y flathub "${packages[@]}"