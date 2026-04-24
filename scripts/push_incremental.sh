#!/usr/bin/env bash
# One folder per commit, push main after each (smallest dirs first).
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
LOG="${ROOT}/push-incremental.log"
exec >>"$LOG" 2>&1
echo "=== start $(date -u +"%Y-%m-%dT%H:%M:%SZ") ==="

find . -mindepth 2 -name .git -type d 2>/dev/null | while read -r g; do rm -rf "$g"; done

if [[ -f .gitignore ]] && grep -qxF 'clone.log' .gitignore; then
  :
else
  printf '\n%s\n' 'clone.log' >>.gitignore 2>/dev/null || echo 'clone.log' >.gitignore
fi

git add -u
git add .gitignore README.md MANIFEST.tsv claude.txt scripts 2>/dev/null || true
if ! git diff --cached --quiet; then
  git commit -m "Remove legacy sources/ layout; add manifest and scripts"
  git push origin main
  echo "pushed metadata batch ok"
else
  echo "no staged changes for metadata batch (already applied?)"
fi

du -sm */ 2>/dev/null | sort -n | while read -r _size dir; do
  base="${dir%/}"
  [[ -d "$base" ]] || continue
  git add "$base"
  if git diff --cached --quiet; then
    echo "skip empty or unchanged: $base"
    continue
  fi
  echo "commit+push: $base"
  git commit -m "Add snapshot: $base" || { echo "commit failed: $base"; continue; }
  if ! git push origin main; then
    echo "PUSH FAILED: $base (see GitHub push protection or network); continuing"
  fi
done

echo "=== done $(date -u +"%Y-%m-%dT%H:%M:%SZ") ==="
