#!/usr/bin/env bash
set -euo pipefail

# --- Help ---
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  cat <<'EOF'
leafhill-stats installer

Usage: ./install-leafhill-stats.sh [path]

  path    Install location (default: ~/.local/bin/leafhill-stats)

Examples:
  ./install-leafhill-stats.sh                              # default location
  ./install-leafhill-stats.sh /usr/local/bin/leafhill-stats # system-wide
EOF
  exit 0
fi

# --- Locate source script ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SOURCE=""
if [[ -f "$SCRIPT_DIR/leafhill-stats" ]]; then
  SOURCE="$SCRIPT_DIR/leafhill-stats"
fi

if [[ -z "$SOURCE" ]]; then
  echo "Error: leafhill-stats not found in $SCRIPT_DIR"
  echo "Make sure the leafhill-stats script is in the same directory as this installer."
  exit 1
fi

# --- Parse install path ---
INSTALL_PATH="${1:-$HOME/.local/bin/leafhill-stats}"
INSTALL_DIR="$(dirname "$INSTALL_PATH")"

# --- Create target directory ---
mkdir -p "$INSTALL_DIR"

# --- Copy and make executable ---
cp "$SOURCE" "$INSTALL_PATH"
chmod +x "$INSTALL_PATH"

# --- Check PATH ---
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
  echo "Note: $INSTALL_DIR is not in your PATH. Add it with:"
  echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
  echo ""
  echo "To make it permanent, add the line above to your ~/.bashrc or ~/.zshrc"
fi

# --- Check Python 3.10+ ---
if command -v python3 &>/dev/null; then
  PY_VERSION="$(python3 --version 2>&1 | awk '{print $2}')"
  PY_MAJOR="$(echo "$PY_VERSION" | cut -d. -f1)"
  PY_MINOR="$(echo "$PY_VERSION" | cut -d. -f2)"
  if [[ "$PY_MAJOR" -lt 3 ]] || { [[ "$PY_MAJOR" -eq 3 ]] && [[ "$PY_MINOR" -lt 10 ]]; }; then
    echo "Warning: Python 3.10+ is required but found Python $PY_VERSION. leafhill-stats may not run correctly."
  fi
else
  echo "Warning: Python 3.10+ is required but python3 was not found. leafhill-stats may not run correctly."
fi

# --- Success ---
echo "leafhill-stats installed to $INSTALL_PATH"
echo "Run 'leafhill-stats' to view your Claude Code usage dashboard."
