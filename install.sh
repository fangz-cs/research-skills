#!/usr/bin/env bash
#
# Install Agent Skills into one or more AI coding agents.
#
# Usage:
#   ./install.sh [target] [skill]
#
#   target : cursor | claude | all   (default: all)
#   skill  : <skill-name> | all      (default: all)
#
# Examples:
#   ./install.sh                       # all skills -> every detected agent
#   ./install.sh claude                # all skills -> Claude Code
#   ./install.sh cursor reading-papers # one skill -> Cursor
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR/skills"

TARGET="${1:-all}"
SKILL="${2:-all}"

if [[ ! -d "$SRC_DIR" ]]; then
  echo "error: skills directory not found at $SRC_DIR" >&2
  exit 1
fi

# Map agent -> personal skills directory.
agent_dir() {
  case "$1" in
    cursor) echo "$HOME/.cursor/skills" ;;
    claude) echo "$HOME/.claude/skills" ;;
    *) return 1 ;;
  esac
}

# Resolve the list of target agents.
case "$TARGET" in
  all) AGENTS=(cursor claude) ;;
  cursor|claude) AGENTS=("$TARGET") ;;
  *)
    echo "error: unknown target '$TARGET' (expected: cursor | claude | all)" >&2
    exit 1
    ;;
esac

# Resolve the list of skills to install.
SKILLS=()
if [[ "$SKILL" == "all" ]]; then
  for d in "$SRC_DIR"/*/; do
    [[ -f "${d}SKILL.md" ]] && SKILLS+=("$(basename "$d")")
  done
else
  if [[ ! -f "$SRC_DIR/$SKILL/SKILL.md" ]]; then
    echo "error: skill '$SKILL' not found in $SRC_DIR" >&2
    exit 1
  fi
  SKILLS=("$SKILL")
fi

if [[ ${#SKILLS[@]} -eq 0 ]]; then
  echo "error: no skills found to install" >&2
  exit 1
fi

installed=0
for agent in "${AGENTS[@]}"; do
  dest="$(agent_dir "$agent")"
  mkdir -p "$dest"
  for s in "${SKILLS[@]}"; do
    rm -rf "${dest:?}/$s"
    cp -r "$SRC_DIR/$s" "$dest/$s"
    echo "installed: $s -> $dest/$s"
    installed=$((installed + 1))
  done
done

echo "done: $installed skill(s) installed. Restart your agent to pick them up."
