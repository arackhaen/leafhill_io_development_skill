#!/usr/bin/env bash
set -euo pipefail

# leafhill-dev installer
# Usage: ./install-leafhill-dev-skill.sh [claude|claude-global|cursor|generic <dir>]
#
# Run from the extracted tar or from the dist/ directory.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Locate source files — works from extracted tar or dist/ folder
if [[ -f "$SCRIPT_DIR/.claude/skills/leafhill-dev/SKILL.md" ]]; then
  # Running from extracted tar root
  SKILL_MD="$SCRIPT_DIR/.claude/skills/leafhill-dev/SKILL.md"
  CONFIG_TEMPLATE=""
  for f in "$SCRIPT_DIR"/leafhill.config.md-*; do
    [[ -f "$f" ]] && CONFIG_TEMPLATE="$f" && break
  done
  CURSORRULES=""
  GENERIC_MD=""
elif [[ -f "$SCRIPT_DIR/claude/leafhill-dev/SKILL.md" ]]; then
  # Running from dist/ folder
  SKILL_MD="$SCRIPT_DIR/claude/leafhill-dev/SKILL.md"
  CONFIG_TEMPLATE="$SCRIPT_DIR/config/leafhill.config.template.md"
  CURSORRULES="$SCRIPT_DIR/cursor/.cursorrules"
  GENERIC_MD="$SCRIPT_DIR/generic/leafhill_dev.md"
else
  echo "Error: Cannot find skill files. Run this script from the extracted tar or the dist/ directory." >&2
  exit 1
fi

usage() {
  echo "leafhill-dev installer"
  echo ""
  echo "Usage: $0 <target> [options]"
  echo ""
  echo "Targets:"
  echo "  claude          Install to current project (.claude/skills/leafhill-dev/)"
  echo "  claude-global   Install globally (~/.claude/skills/leafhill-dev/)"
  echo "  cursor          Install .cursorrules to current project"
  echo "  generic <dir>   Copy leafhill_dev.md to the specified directory"
  echo ""
  echo "All targets optionally copy leafhill.config.md to the project root."
}

install_config() {
  local target_dir="$1"
  if [[ -f "$CONFIG_TEMPLATE" ]]; then
    if [[ -f "$target_dir/leafhill.config.md" ]]; then
      echo "  leafhill.config.md already exists, skipping."
    else
      cp "$CONFIG_TEMPLATE" "$target_dir/leafhill.config.md"
      echo "  Copied leafhill.config.md — edit it to configure the skill."
    fi
  fi
}

TARGET="${1:-}"

if [[ -z "$TARGET" ]]; then
  usage
  exit 0
fi

case "$TARGET" in
  claude)
    PROJECT_ROOT="$(pwd)"
    mkdir -p "$PROJECT_ROOT/.claude/skills/leafhill-dev"
    cp "$SKILL_MD" "$PROJECT_ROOT/.claude/skills/leafhill-dev/SKILL.md"
    echo "Installed leafhill-dev to $PROJECT_ROOT/.claude/skills/leafhill-dev/"
    install_config "$PROJECT_ROOT"
    echo "Done. Start a new Claude Code session to activate."
    ;;

  claude-global)
    GLOBAL_DIR="$HOME/.claude/skills/leafhill-dev"
    mkdir -p "$GLOBAL_DIR"
    cp "$SKILL_MD" "$GLOBAL_DIR/SKILL.md"
    echo "Installed leafhill-dev globally to $GLOBAL_DIR/"
    echo "Done. Start a new Claude Code session to activate."
    ;;

  cursor)
    PROJECT_ROOT="$(pwd)"
    if [[ -z "$CURSORRULES" ]]; then
      echo "Error: Cursor install requires running from the dist/ folder (needs .cursorrules source)." >&2
      exit 1
    fi
    if [[ -f "$PROJECT_ROOT/.cursorrules" ]]; then
      echo "Warning: .cursorrules already exists. Overwrite? [y/N]"
      read -r REPLY
      if [[ "$REPLY" != "y" && "$REPLY" != "Y" ]]; then
        echo "Aborted."
        exit 0
      fi
    fi
    cp "$CURSORRULES" "$PROJECT_ROOT/.cursorrules"
    echo "Installed .cursorrules to $PROJECT_ROOT/"
    install_config "$PROJECT_ROOT"
    echo "Done. Reload Cursor (Cmd/Ctrl+Shift+P > Reload Window)."
    ;;

  generic)
    TARGET_DIR="${2:-}"
    if [[ -z "$TARGET_DIR" ]]; then
      echo "Error: Specify a target directory. Usage: $0 generic <dir>" >&2
      exit 1
    fi
    if [[ -z "$GENERIC_MD" ]]; then
      echo "Error: Generic install requires running from the dist/ folder." >&2
      exit 1
    fi
    if [[ ! -d "$TARGET_DIR" ]]; then
      echo "Error: Directory '$TARGET_DIR' does not exist." >&2
      exit 1
    fi
    cp "$GENERIC_MD" "$TARGET_DIR/leafhill_dev.md"
    echo "Installed leafhill_dev.md to $TARGET_DIR/"
    install_config "$(pwd)"
    echo "Done. Configure your AI tool to load the file."
    ;;

  *)
    echo "Error: Unknown target '$TARGET'" >&2
    echo ""
    usage
    exit 1
    ;;
esac
