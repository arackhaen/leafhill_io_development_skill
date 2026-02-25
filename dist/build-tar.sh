#!/usr/bin/env bash
set -euo pipefail

# leafhill-dev build script
# Usage: ./build-tar.sh [patch|minor|major]  (default: patch)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
VERSION_FILE="$PROJECT_DIR/application_version.txt"
OUTPUT="$SCRIPT_DIR/leafhill-dev.tar.gz"

# --- Parse bump type ---
BUMP_TYPE="${1:-patch}"
if [[ "$BUMP_TYPE" != "patch" && "$BUMP_TYPE" != "minor" && "$BUMP_TYPE" != "major" ]]; then
  echo "Error: Invalid bump type '$BUMP_TYPE'. Must be patch, minor, or major." >&2
  exit 1
fi

# --- Read current version ---
if [[ ! -f "$VERSION_FILE" ]]; then
  echo "Error: Version file not found at $VERSION_FILE" >&2
  exit 1
fi

CURRENT_VERSION="$(tr -d '[:space:]' < "$VERSION_FILE")"
if [[ ! "$CURRENT_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: Invalid version format '$CURRENT_VERSION'. Expected MAJOR.MINOR.PATCH" >&2
  exit 1
fi

IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"

# --- Compute new version ---
case "$BUMP_TYPE" in
  patch) NEW_PATCH=$((PATCH + 1)); NEW_VERSION="$MAJOR.$MINOR.$NEW_PATCH" ;;
  minor) NEW_MINOR=$((MINOR + 1)); NEW_VERSION="$MAJOR.$NEW_MINOR.0" ;;
  major) NEW_MAJOR=$((MAJOR + 1)); NEW_VERSION="$NEW_MAJOR.0.0" ;;
esac

# --- Monotonic guard ---
version_to_int() {
  IFS='.' read -r a b c <<< "$1"
  echo $(( a * 1000000 + b * 1000 + c ))
}

CURRENT_INT="$(version_to_int "$CURRENT_VERSION")"
NEW_INT="$(version_to_int "$NEW_VERSION")"

if (( NEW_INT <= CURRENT_INT )); then
  echo "Error: Version regression blocked. $NEW_VERSION <= $CURRENT_VERSION" >&2
  exit 1
fi

echo "Bumping version: $CURRENT_VERSION -> $NEW_VERSION ($BUMP_TYPE)"

# --- Update version in all files ---
# Uses exact old version string for safety

# 1. SKILL.md (root) — YAML frontmatter
sed -i "s/version: \"$CURRENT_VERSION\"/version: \"$NEW_VERSION\"/" "$PROJECT_DIR/SKILL.md"

# 2. dist/claude/leafhill-dev/SKILL.md — same pattern
sed -i "s/version: \"$CURRENT_VERSION\"/version: \"$NEW_VERSION\"/" "$SCRIPT_DIR/claude/leafhill-dev/SKILL.md"

# 3. INSTALL.md — code block example
sed -i "s/version: \"$CURRENT_VERSION\"/version: \"$NEW_VERSION\"/" "$PROJECT_DIR/INSTALL.md"

# 4. README.md — "Current version: **X.Y.Z**"
sed -i "s/Current version: \*\*$CURRENT_VERSION\*\*/Current version: \*\*$NEW_VERSION\*\*/" "$PROJECT_DIR/README.md"

# 5. dist/cursor/.cursorrules — "(vX.Y.Z)" in header
sed -i "s/(v$CURRENT_VERSION)/(v$NEW_VERSION)/" "$SCRIPT_DIR/cursor/.cursorrules"

# 6. txt/distribution-guide.txt — "Version: X.Y.Z"
sed -i "s/Version: $CURRENT_VERSION/Version: $NEW_VERSION/" "$PROJECT_DIR/txt/distribution-guide.txt"

# 7. dist/generic/leafhill_dev.md — "**Version:** X.Y.Z"
sed -i "s/\*\*Version:\*\* $CURRENT_VERSION/\*\*Version:\*\* $NEW_VERSION/" "$SCRIPT_DIR/generic/leafhill_dev.md"

# 8. application_version.txt — full replacement (last for pseudo-atomic safety)
echo "$NEW_VERSION" > "$VERSION_FILE"

echo "Updated version in all 8 files."

# --- Build tar.gz ---
STAGING_DIR="$(mktemp -d)"
trap 'rm -rf "$STAGING_DIR"' EXIT

mkdir -p "$STAGING_DIR/.claude/skills/leafhill-dev/references"
cp "$SCRIPT_DIR/claude/leafhill-dev/SKILL.md" "$STAGING_DIR/.claude/skills/leafhill-dev/SKILL.md"
cp "$SCRIPT_DIR/claude/leafhill-dev/references/common-specs.md" "$STAGING_DIR/.claude/skills/leafhill-dev/references/common-specs.md"
cp "$PROJECT_DIR/leafhill.config.template.md" "$STAGING_DIR/leafhill.config.md-$NEW_VERSION"
cp "$SCRIPT_DIR/install-leafhill-dev-skill.sh" "$STAGING_DIR/install-leafhill-dev-skill.sh"

tar czf "$OUTPUT" -C "$STAGING_DIR" .claude "leafhill.config.md-$NEW_VERSION" install-leafhill-dev-skill.sh

echo ""
echo "Build successful: $OUTPUT"
echo "Version: $NEW_VERSION"

# --- Audit reminder for minor/major bumps ---
if [[ "$BUMP_TYPE" == "minor" || "$BUMP_TYPE" == "major" ]]; then
  echo ""
  echo "=============================================="
  echo "  RELEASE AUDIT REQUIRED ($BUMP_TYPE bump)"
  echo "=============================================="
  echo ""
  echo "Before releasing v$NEW_VERSION, perform the Release Audit Protocol"
  echo "(Section 3.1 in SKILL.md):"
  echo ""
  echo "  1. OWASP Top 10+ review (adapted for AI skill instructions)"
  echo "  2. ISO 27001 compliance checks"
  echo "  3. Quality review (consistency, completeness, version alignment)"
  echo ""
  echo "Critical and High severity findings must be resolved before release."
  echo "=============================================="
fi
