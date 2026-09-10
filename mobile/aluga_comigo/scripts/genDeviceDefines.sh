#!/usr/bin/env bash
# Gera dart_defines.device.json para celular físico (mesma Wi-Fi).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

DEFAULT_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0"

run_supabase() {
  if command -v supabase >/dev/null 2>&1; then
    supabase "$@"
  else
    npx --yes supabase@latest "$@"
  fi
}

LAN_IP="$(ip route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src") print $(i+1); exit}')"
LAN_IP="${LAN_IP:-$(hostname -I 2>/dev/null | awk '{print $1}')}"

if [[ -z "$LAN_IP" ]]; then
  echo "Não foi possível detectar o IP da rede local." >&2
  exit 1
fi

ANON_KEY="$DEFAULT_ANON_KEY"
ENV_OUT="$(run_supabase status -o env 2>/dev/null || true)"
if [[ -n "$ENV_OUT" ]]; then
  KEY="$(echo "$ENV_OUT" | sed -n 's/^ANON_KEY="\(.*\)"$/\1/p' | head -n 1)"
  [[ -z "$KEY" ]] && KEY="$(echo "$ENV_OUT" | sed -n 's/^PUBLISHABLE_KEY="\(.*\)"$/\1/p' | head -n 1)"
  [[ -n "$KEY" ]] && ANON_KEY="$KEY"
fi

cat >dart_defines.device.json <<EOF
{
  "SUPABASE_URL": "http://${LAN_IP}:54321",
  "SUPABASE_ANON_KEY": "${ANON_KEY}"
}
EOF

echo "dart_defines.device.json gerado:"
echo "  SUPABASE_URL=http://${LAN_IP}:54321"
