#!/usr/bin/env bash
set -euo pipefail

# deploy-leafhill-dev.sh
# Deploys the leafhill-dev skill + leafhill-stats to a project.
#
# Usage:
#   cd /path/to/your/project
#   deploy-leafhill-dev.sh --dist-dir /path/to/dist
#
# What it deploys:
#   .claude/skills/leafhill-dev/SKILL.md           — skill file
#   .claude/skills/leafhill-dev/references/         — reference docs
#   leafhill.config.md                              — config template (skip if exists)
#   leafhill-stats                                  — installed to ~/.local/bin/

# --- Parse arguments ---
DIST_DIR=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dist-dir)
      DIST_DIR="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: deploy-leafhill-dev.sh --dist-dir <path>"
      echo ""
      echo "  --dist-dir <path>  Path to the leafhill-dev dist folder (required)"
      echo ""
      echo "Run from your project root. Deploys the skill to .claude/skills/leafhill-dev/"
      exit 0
      ;;
    *)
      echo "Error: Unknown argument '$1'. Use --help for usage." >&2
      exit 1
      ;;
  esac
done

if [[ -z "$DIST_DIR" ]]; then
  echo "Error: --dist-dir is required." >&2
  echo "Usage: deploy-leafhill-dev.sh --dist-dir /path/to/dist" >&2
  exit 1
fi

PROJECT_DIR="$(pwd)"

# --- Validate source files exist ---
if [[ ! -f "$DIST_DIR/claude/leafhill-dev/SKILL.md" ]]; then
  echo "Error: SKILL.md not found in $DIST_DIR/claude/leafhill-dev/" >&2
  echo "Check the --dist-dir path points to the leafhill-dev dist folder." >&2
  exit 1
fi

echo "Deploying leafhill-dev to: $PROJECT_DIR"
echo "Source: $DIST_DIR"
echo ""

# --- 1. Deploy skill files ---
mkdir -p "$PROJECT_DIR/.claude/skills/leafhill-dev/references"

cp "$DIST_DIR/claude/leafhill-dev/SKILL.md" \
   "$PROJECT_DIR/.claude/skills/leafhill-dev/SKILL.md"

if [[ -f "$DIST_DIR/claude/leafhill-dev/references/common-specs.md" ]]; then
  cp "$DIST_DIR/claude/leafhill-dev/references/common-specs.md" \
     "$PROJECT_DIR/.claude/skills/leafhill-dev/references/common-specs.md"
fi

echo "[ok] Skill deployed to .claude/skills/leafhill-dev/"

# --- 2. Deploy config template (skip if exists) ---
if [[ -f "$PROJECT_DIR/leafhill.config.md" ]]; then
  echo "[skip] leafhill.config.md already exists"
else
  # Find versioned template or plain template
  CONFIG_SRC=""
  if [[ -f "$DIST_DIR/config/leafhill.config.template.md" ]]; then
    CONFIG_SRC="$DIST_DIR/config/leafhill.config.template.md"
  else
    # Check for versioned config in dist root (from tar extraction)
    for f in "$DIST_DIR"/leafhill.config.md-*; do
      [[ -f "$f" ]] && CONFIG_SRC="$f" && break
    done
  fi

  if [[ -n "$CONFIG_SRC" ]]; then
    cp "$CONFIG_SRC" "$PROJECT_DIR/leafhill.config.md"
    echo "[ok] Config template copied to leafhill.config.md"
  else
    echo "[skip] No config template found"
  fi
fi

# --- 3. Deploy leafhill-stats ---
if [[ -f "$DIST_DIR/leafhill-stats" ]]; then
  STATS_DIR="$HOME/.local/bin"
  mkdir -p "$STATS_DIR"
  cp "$DIST_DIR/leafhill-stats" "$STATS_DIR/leafhill-stats"
  chmod +x "$STATS_DIR/leafhill-stats"
  echo "[ok] leafhill-stats installed to $STATS_DIR/leafhill-stats"

  if [[ ":$PATH:" != *":$STATS_DIR:"* ]]; then
    echo "     Note: $STATS_DIR is not in PATH. Add it with:"
    echo "       export PATH=\"\$HOME/.local/bin:\$PATH\""
  fi
else
  echo "[skip] leafhill-stats not found in dist"
fi

# --- Summary ---
echo ""
echo "Done. Start a new Claude Code session to activate the skill."
