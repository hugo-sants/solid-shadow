#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGE_FILE="$REPO_ROOT/packages.txt"

if ! command -v dnf >/dev/null 2>&1; then
    echo "Error: DNF is required."
    exit 1
fi

if [[ ! -f "$PACKAGE_FILE" ]]; then
    echo "Error: packages.txt not found:"
    echo "  $PACKAGE_FILE"
    exit 1
fi

mapfile -t packages < <(
    grep -vE '^[[:space:]]*(#|$)' "$PACKAGE_FILE"
)

if [[ "${#packages[@]}" -eq 0 ]]; then
    echo "No packages found."
    exit 0
fi

echo "Installing customization packages:"
printf '  %s\n' "${packages[@]}"
echo

sudo dnf install -y "${packages[@]}"