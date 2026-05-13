#!/usr/bin/env bash
#
# Foundry install — registers /foundry, /anvil, /forge, and /switch as slash
# commands in the current project by symlinking them into .claude/commands/.
#
# Usage (from your project root):
#
#   ./foundry/install.sh
#
# Re-running is safe. Existing files that conflict are reported, never overwritten.

set -euo pipefail

FOUNDRY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$(pwd)"

# --- Sanity checks --------------------------------------------------------

if [[ "$TARGET_DIR" == "$FOUNDRY_DIR" ]]; then
  cat >&2 <<EOF
Error: this script must be run from your project root, not from inside foundry/.

  cd /path/to/your-project
  ./foundry/install.sh

Aborting.
EOF
  exit 1
fi

if [[ ! -d "$TARGET_DIR/foundry" ]]; then
  cat >&2 <<EOF
Error: no foundry/ folder found at $TARGET_DIR.

Move (or copy) the foundry folder to your project root so the layout looks like:

  $TARGET_DIR/
    foundry/
    .claude/        (will be created if missing)

Then re-run from the project root:

  ./foundry/install.sh

Aborting.
EOF
  exit 1
fi

if [[ ! -d "$FOUNDRY_DIR/commands" ]]; then
  echo "Error: $FOUNDRY_DIR/commands not found. Is your foundry folder complete?" >&2
  exit 1
fi

# --- Install symlinks -----------------------------------------------------

mkdir -p "$TARGET_DIR/.claude/commands"

COMMANDS=(foundry anvil forge switch)
INSTALLED=()
SKIPPED=()
CONFLICTS=()

for cmd in "${COMMANDS[@]}"; do
  src_rel="../../foundry/commands/${cmd}.md"
  src_abs="$FOUNDRY_DIR/commands/${cmd}.md"
  dest="$TARGET_DIR/.claude/commands/${cmd}.md"

  if [[ ! -f "$src_abs" ]]; then
    CONFLICTS+=("${cmd} — source file missing at $src_abs")
    continue
  fi

  if [[ -L "$dest" ]]; then
    current_target="$(readlink "$dest")"
    if [[ "$current_target" == "$src_rel" ]]; then
      SKIPPED+=("/${cmd}")
      continue
    else
      CONFLICTS+=("/${cmd} — symlink already exists pointing elsewhere ($current_target)")
      continue
    fi
  elif [[ -e "$dest" ]]; then
    CONFLICTS+=("/${cmd} — a regular file already exists at $dest")
    continue
  fi

  ln -s "$src_rel" "$dest"
  INSTALLED+=("/${cmd}")
done

# --- Report ---------------------------------------------------------------

echo
echo "Foundry install summary"
echo "-----------------------"

if [[ ${#INSTALLED[@]} -gt 0 ]]; then
  echo
  echo "Installed:"
  for c in "${INSTALLED[@]}"; do echo "  $c"; done
fi

if [[ ${#SKIPPED[@]} -gt 0 ]]; then
  echo
  echo "Already installed (no change):"
  for c in "${SKIPPED[@]}"; do echo "  $c"; done
fi

if [[ ${#CONFLICTS[@]} -gt 0 ]]; then
  echo
  echo "Conflicts (not installed):"
  for c in "${CONFLICTS[@]}"; do echo "  $c"; done
  echo
  echo "Resolve each conflict (rename or remove the existing file), then re-run." >&2
  exit 1
fi

echo
echo "Done. From this project root, you can now use:"
echo "  /foundry   show the welcome screen and choose a tool"
echo "  /anvil     jump straight to Anvil"
echo "  /forge     jump straight to Forge"
echo "  /switch    swap tools mid-session"
echo
