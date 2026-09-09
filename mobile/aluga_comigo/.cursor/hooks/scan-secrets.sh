#!/usr/bin/env bash
set -euo pipefail
input=$(cat)
prompt=$(echo "$input" | jq -r '.prompt // empty')

PATTERNS=(
  'sk-[a-zA-Z0-9]{20,}'
  'AKIA[0-9A-Z]{16}'
  '-----BEGIN.*PRIVATE KEY-----'
)

for pattern in "${PATTERNS[@]}"; do
  if echo "$prompt" | grep -qE "$pattern"; then
    jq -n '{
      permission: "allow",
      userMessage: "Possível secret detectado no prompt. Remova antes de enviar."
    }'
    exit 0
  fi
done

echo '{}'
