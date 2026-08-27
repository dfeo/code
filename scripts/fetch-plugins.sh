#!/bin/bash
# Fetch and bundle community plugins for the Code editor.
#
# Uses GNU sed (gsed) because macOS BSD sed does not support \14 in
# replacement strings (treated as \1 + literal "4").

# Prefer gsed; fall back to sed if gsed isn't available.
SED="$(command -v gsed || command -v sed)"
#
# Reads data/plugins.txt (one plugin id per line) and installs each via lpm
# into data/plugins/ so they ship with the app on every build.
#
# Re-running is idempotent; lpm upgrades if a newer version is available.
#
# Requires: lpm binary in Code.app/Contents/Resources/plugins/plugin_manager/

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PLUGINS_FILE="$REPO_ROOT/data/plugins.txt"
DATA_DIR="$REPO_ROOT/data"
PLUGINS_DIR="$DATA_DIR/plugins"
LPM_CACHE="$REPO_ROOT/lpm-cache"

# Pick the lpm binary from the most recent build (any arch).
LPM_BIN="$(cd "$REPO_ROOT" && find build-*-darwin -name 'lpm.*-darwin' 2>/dev/null | head -1)"
if [[ -n "$LPM_BIN" ]]; then
  LPM_BIN="$REPO_ROOT/$LPM_BIN"
fi

if [[ -z "$LPM_BIN" || ! -x "$LPM_BIN" ]]; then
  echo "fetch-plugins: lpm binary not found. Run ./scripts/build.sh first to build the app." >&2
  exit 1
fi

mkdir -p "$PLUGINS_DIR" "$LPM_CACHE"

if [[ ! -f "$PLUGINS_FILE" ]]; then
  echo "fetch-plugins: $PLUGINS_FILE not found" >&2
  exit 1
fi

echo "fetch-plugins: bundling plugins listed in $PLUGINS_FILE"

# Initialize lpm cache (no-op if already initialized)
"$LPM_BIN" --userdir="$DATA_DIR" --cachedir="$LPM_CACHE" init >/dev/null 2>&1 || true

while read -r PLUGIN; do
  # Skip blanks and comments
  [[ -z "$PLUGIN" || "$PLUGIN" =~ ^# ]] && continue

  echo "  installing $PLUGIN..."
  "$LPM_BIN" install --force \
    --userdir="$DATA_DIR" \
    --cachedir="$LPM_CACHE" \
    --datadir="$DATA_DIR" \
    "$PLUGIN" >/dev/null 2>&1 || echo "    (warning: $PLUGIN install failed)"

  # Patch the mod-version header to 4.0.0 (matches Code.app's MOD_VERSION)
  PLUGIN_FILE="$PLUGINS_DIR/${PLUGIN}.lua"
  if [[ -f "$PLUGIN_FILE" ]]; then
    # Match: -- mod-version:[spaces]N(.M)[trailing]
    # Replace with: -- mod-version:4.0.0[trailing] (no space between : and 4)
    # Trick: capture the prefix WITHOUT the colon in \1, then put ":4.0.0" in the
    # replacement. This avoids the "after the colon space" leaking through.
    "$SED" -i -E 's/^(--+[[:space:]]*mod-version):[[:space:]]+([0-9]+(\.[0-9]+)*)(.*)$/\1:4.0.0\4/' "$PLUGIN_FILE"
  fi
done < "$PLUGINS_FILE"

# Patch ALL plugin files to mod-version:4.0.0 to be safe.
# Match anywhere on the line, replace mod-version:[spaces]N(.M) with 4.0.0
# (no space between : and 4 — Code.app's regex --.*mod-version:(\d+) doesn't allow one).
# This catches both repo-bundled plugins (e.g. linewrapping has -- mod-version: 4 --priority:10)
# and lpm-installed ones (mod-version:4.0.0).
for f in "$PLUGINS_DIR"/*.lua; do
  [[ -f "$f" ]] || continue
  # \14 in replacement is \1 + literal "4" (gnu-sed quirk). Use \1:4.0.0\4 instead.
  # Use [[:space:]]* (zero or more) so it works for headers with no space after :.
  "$SED" -i -E 's/^(--+[[:space:]]*mod-version):[[:space:]]*([0-9]+(\.[0-9]+)*)(.*)$/\1:4.0.0\4/' "$f"
done

echo "fetch-plugins: done"