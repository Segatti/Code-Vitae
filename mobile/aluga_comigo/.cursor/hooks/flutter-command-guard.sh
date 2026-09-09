#!/usr/bin/env bash
# Encoraja analyze antes de test suite completa
set -euo pipefail
input=$(cat)
command=$(echo "$input" | jq -r '.command // empty')

if [[ "$command" == "flutter test" ]] && [[ "$command" != *"test/"* ]] && [[ "$command" != *"--name"* ]]; then
  jq -n '{
    permission: "allow",
    userMessage: "Suite completa detectada. Prefira: dart analyze && flutter test test/app/modules/[modulo]/"
  }'
  exit 0
fi

jq -n '{permission: "allow"}'
