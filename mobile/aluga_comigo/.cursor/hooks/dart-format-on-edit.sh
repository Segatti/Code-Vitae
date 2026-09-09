#!/usr/bin/env bash
set -euo pipefail
input=$(cat)
file_path=$(echo "$input" | jq -r '.file_path // .path // empty')

if [[ -z "$file_path" ]] || [[ ! "$file_path" == *.dart ]]; then
  echo '{}'
  exit 0
fi

if command -v dart >/dev/null 2>&1; then
  dart format "$file_path" 2>/dev/null || true
fi

echo '{}'
