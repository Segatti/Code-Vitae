#!/usr/bin/env bash
# Bloqueia comandos destrutivos e git push não autorizado
set -euo pipefail
input=$(cat)
command=$(python3 -c "import json,sys; print(json.load(sys.stdin).get('command',''))" <<<"$input")

BLOCKED=(
  'rm -rf /'
  'rm -rf ~'
  'git push --force'
  'git reset --hard'
  'flutter clean && rm -rf'
)

for pattern in "${BLOCKED[@]}"; do
  if [[ "$command" == *"$pattern"* ]]; then
    python3 -c "import json; print(json.dumps({'permission':'deny','userMessage':'Bloqueado pela política do projeto: $pattern'}))"
    exit 0
  fi
done

if [[ "$command" == git\ push* ]] && [[ "$command" != *"ALLOW_PUSH"* ]]; then
  python3 -c "import json; print(json.dumps({'permission':'deny','userMessage':'git push bloqueado. Use ALLOW_PUSH no prompt se autorizado.'}))"
  exit 0
fi

python3 -c "import json; print(json.dumps({'permission':'allow'}))"
