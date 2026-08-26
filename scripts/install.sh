#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Creating backup..."
"$SCRIPT_DIR/backup.sh"

echo
echo "==> Applying GNOME extension configurations..."
"$SCRIPT_DIR/dconf.sh" extensions

echo
echo "Installation completed successfully."