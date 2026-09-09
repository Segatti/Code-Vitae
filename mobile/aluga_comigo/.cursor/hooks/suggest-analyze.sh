#!/usr/bin/env bash
set -euo pipefail
input=$(cat)

if command -v dart >/dev/null 2>&1; then
  if dart analyze 2>&1 | head -20 | grep -q "error\|Error"; then
    jq -n '{
      followup_message: "dart analyze encontrou erros. Corrija antes de concluir. Use /fix-ci se necessário."
    }'
    exit 0
  fi
fi

echo '{}'
