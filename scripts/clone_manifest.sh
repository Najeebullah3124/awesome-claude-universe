#!/usr/bin/env bash
# Clone repos from manifest TSV: folder<TAB>url<TAB>owner<TAB>repo
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MANIFEST="${1:-$ROOT/MANIFEST.tsv}"
cd "$ROOT"

url_override() {
  local url="$1"
  case "$url" in
    https://github.com/gtanczyk/gstack) echo "https://github.com/garrytan/gstack" ;;
    *) echo "$url" ;;
  esac
}

while IFS=$'\t' read -r folder url _owner _repo; do
  [[ -z "${folder:-}" || "${folder:0:1}" == "#" ]] && continue
  real_url="$(url_override "$url")"
  if [[ -d "$folder" ]] && [[ -n "$(ls -A "$folder" 2>/dev/null || true)" ]]; then
    echo "skip exists: $folder"
    continue
  fi
  echo "clone: $folder <= $real_url"
  rm -rf "$folder"
  if ! git clone --depth 1 "$real_url" "$folder"; then
    echo "FAILED: $folder" >&2
    continue
  fi
  rm -rf "$folder/.git"
done < "$MANIFEST"
