#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

readonly DOTFILES_ROOT="${DOTFILES:-$HOME/.dotfiles}"
readonly SKILLS_SOURCE="$DOTFILES_ROOT/agents/skills"

if [[ ! -d "$SKILLS_SOURCE" ]]; then
  echo "Skills source not found: $SKILLS_SOURCE" >&2
  exit 1
fi

link_skills() {
  local target="$1"
  local parent
  parent="$(dirname "$target")"
  mkdir -p "$parent"

  if [[ -L "$target" ]]; then
    if [[ "$(readlink "$target")" == "$SKILLS_SOURCE" ]]; then
      echo "OK $target"
      return
    fi
    echo "Refusing to replace unexpected symlink: $target" >&2
    exit 1
  fi

  if [[ -e "$target" ]]; then
    echo "Refusing to replace existing path: $target" >&2
    exit 1
  fi

  ln -s "$SKILLS_SOURCE" "$target"
  echo "Linked $target -> $SKILLS_SOURCE"
}

link_skills "$HOME/.agents/skills"
link_skills "$HOME/.config/opencode/skills"
link_skills "$HOME/.claude/skills"
link_skills "$HOME/.gemini/skills"
link_skills "$HOME/.gemini/config/skills"
link_skills "$HOME/.gemini/antigravity/skills"
link_skills "$HOME/.cursor/skills"
link_skills "$HOME/.qoder/skills"

git -C "$DOTFILES_ROOT" config core.hooksPath .githooks

echo
echo "Codex, Kimi Code, and Warp discover ~/.agents/skills directly."
echo "Other supported agents now share the same canonical skills directory."
