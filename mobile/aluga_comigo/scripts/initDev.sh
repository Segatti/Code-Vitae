#!/usr/bin/env bash
# Sobe Supabase local, aplica migrations e gera dart_defines.json para dev.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()  { echo -e "${GREEN}[initDev]${NC} $*"; }
warn() { echo -e "${YELLOW}[initDev]${NC} $*"; }
err()  { echo -e "${RED}[initDev]${NC} $*" >&2; }

run_supabase() {
  if command -v supabase >/dev/null 2>&1; then
    supabase "$@"
    return
  fi

  if command -v npx >/dev/null 2>&1; then
    npx --yes supabase@latest "$@"
    return
  fi

  err "Supabase CLI não encontrado."
  err "Instale com: npm install -g supabase"
  err "Ou garanta que Node.js/npx está disponível."
  exit 1
}

# Chaves padrão do Supabase local (fallback documentado)
DEFAULT_LOCAL_API_URL="http://127.0.0.1:54321"
DEFAULT_LOCAL_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0"

# Artboard de referência para .w() / .h() / .sp() (padrão Figma / iPhone 14 — 390×844 pt lógicos).
DESIGN_SCREEN_WIDTH="390"
DESIGN_SCREEN_HEIGHT="844"

parse_env_value() {
  local key="$1"
  local env_output="$2"
  echo "$env_output" | sed -n "s/^${key}=\"\\(.*\\)\"$/\\1/p" | head -n 1
}

read_local_credentials() {
  local env_output json_line

  # 1) Formato mais estável: supabase status -o env
  env_output="$(run_supabase status -o env 2>/dev/null || true)"
  if [[ -n "$env_output" ]]; then
    API_URL="$(parse_env_value "API_URL" "$env_output")"
    ANON_KEY="$(parse_env_value "ANON_KEY" "$env_output")"
    if [[ -z "$ANON_KEY" ]]; then
      ANON_KEY="$(parse_env_value "PUBLISHABLE_KEY" "$env_output")"
    fi
  fi

  # 2) JSON (ignora WARN no stderr; pega só a linha que começa com {)
  if [[ -z "$API_URL" || -z "$ANON_KEY" ]]; then
    json_line="$(run_supabase status -o json 2>&1 | grep -E '^\{' | tail -n 1 || true)"
    if [[ -n "$json_line" ]] && command -v jq >/dev/null 2>&1; then
      if [[ -z "$API_URL" ]]; then
        API_URL="$(echo "$json_line" | jq -r '
          .API_URL // .api_url // .APIUrl // empty
        ')"
      fi
      if [[ -z "$ANON_KEY" ]]; then
        ANON_KEY="$(echo "$json_line" | jq -r '
          .ANON_KEY // .anon_key //
          .PUBLISHABLE_KEY // .publishable_key //
          .SUPABASE_ANON_KEY // empty
        ')"
      fi
    fi
  fi

  # 3) Texto plano (último recurso antes do fallback fixo)
  if [[ -z "$API_URL" || -z "$ANON_KEY" ]]; then
    local text_output
    text_output="$(run_supabase status 2>/dev/null || true)"
    if [[ -z "$API_URL" ]]; then
      API_URL="$(echo "$text_output" | awk '/API URL/ { print $3; exit }')"
      [[ -z "$API_URL" ]] && API_URL="$(echo "$text_output" | awk '$1 == "API_URL:" { print $2; exit }')"
    fi
    if [[ -z "$ANON_KEY" ]]; then
      ANON_KEY="$(echo "$text_output" | awk '/anon key/ { print $3; exit }')"
      [[ -z "$ANON_KEY" ]] && ANON_KEY="$(echo "$text_output" | awk '$1 == "anon" && $2 == "key:" { print $3; exit }')"
    fi
  fi

  # 4) Fallback: containers locais usam credenciais fixas conhecidas
  if [[ -z "$API_URL" || -z "$ANON_KEY" ]]; then
    if docker ps --format '{{.Names}}' 2>/dev/null | grep -q 'supabase'; then
      warn "Não leu credenciais do 'supabase status'; usando defaults locais conhecidos."
      API_URL="$DEFAULT_LOCAL_API_URL"
      ANON_KEY="$DEFAULT_LOCAL_ANON_KEY"
    fi
  fi
}

write_dart_defines() {
  local url="$1"
  local anon_key="$2"
  local backend_url="$3"
  local output_file="$4"

  cat >"$output_file" <<EOF
{
  "SUPABASE_URL": "${url}",
  "SUPABASE_ANON_KEY": "${anon_key}",
  "BACKEND_API_URL": "${backend_url}",
  "DESIGN_SCREEN_WIDTH": "${DESIGN_SCREEN_WIDTH}",
  "DESIGN_SCREEN_HEIGHT": "${DESIGN_SCREEN_HEIGHT}"
}
EOF
}

detect_lan_ip() {
  local ip=""
  ip="$(ip route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src") print $(i+1); exit}')"
  if [[ -z "$ip" ]]; then
    ip="$(hostname -I 2>/dev/null | awk '{print $1}')"
  fi
  echo "$ip"
}

log "Verificando Docker..."
if ! command -v docker >/dev/null 2>&1; then
  err "Docker não está instalado."
  echo ""
  echo "  Ubuntu/Debian (recomendado):"
  echo "    sudo apt update"
  echo "    sudo apt install -y docker.io"
  echo "    sudo usermod -aG docker \"\$USER\""
  echo "    newgrp docker    # ou faça logout/login"
  echo ""
  echo "  Depois: sudo systemctl enable --now docker"
  echo "  Teste:   docker info"
  echo ""
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  err "Docker está instalado, mas o daemon não está rodando."
  echo ""
  echo "  Linux:"
  echo "    sudo systemctl start docker"
  echo ""
  echo "  Docker Desktop (Windows/macOS): abra o aplicativo e aguarde iniciar."
  echo ""
  exit 1
fi

if [[ ! -f supabase/config.toml ]]; then
  warn "supabase/config.toml não encontrado — executando supabase init..."
  run_supabase init
fi

log "Subindo Supabase local (pode demorar na primeira vez)..."
run_supabase start

log "Aplicando migrations (db reset)..."
run_supabase db reset --yes

log "Lendo credenciais locais..."
API_URL=""
ANON_KEY=""
read_local_credentials

if [[ -z "$API_URL" || -z "$ANON_KEY" ]]; then
  err "Não foi possível obter API_URL/ANON_KEY."
  echo ""
  echo "  Diagnóstico:"
  echo "    supabase status"
  echo "    supabase status -o env"
  echo "    docker ps | grep supabase"
  echo ""
  run_supabase status 2>&1 || true
  exit 1
fi

BACKEND_URL="http://127.0.0.1:8080"
BACKEND_ANDROID_URL="http://10.0.2.2:8080"

log "Gerando dart_defines.json (iOS / simulador / desktop)..."
write_dart_defines "$API_URL" "$ANON_KEY" "$BACKEND_URL" "dart_defines.json"

log "Gerando dart_defines.android.json (emulador Android → 10.0.2.2)..."
ANDROID_URL="${API_URL/127.0.0.1/10.0.2.2}"
write_dart_defines "$ANDROID_URL" "$ANON_KEY" "$BACKEND_ANDROID_URL" "dart_defines.android.json"

LAN_IP="$(detect_lan_ip)"
if [[ -n "$LAN_IP" ]]; then
  log "Gerando dart_defines.device.json (celular físico → ${LAN_IP})..."
  DEVICE_URL="${API_URL/127.0.0.1/${LAN_IP}}"
  BACKEND_DEVICE_URL="http://${LAN_IP}:8080"
  write_dart_defines "$DEVICE_URL" "$ANON_KEY" "$BACKEND_DEVICE_URL" "dart_defines.device.json"
else
  warn "Não detectou IP da rede local — dart_defines.device.json não gerado."
fi

if command -v flutter >/dev/null 2>&1; then
  log "flutter pub get..."
  flutter pub get
else
  warn "Flutter não encontrado no PATH — pulando pub get."
fi

echo ""
log "Ambiente local pronto!"
echo ""
echo "  Studio:    http://127.0.0.1:54323"
echo "  API:       ${API_URL}"
echo "  E-mail dev: http://127.0.0.1:54324 (Inbucket)"
echo ""
echo "  Contas demo (senha: demo123):"
echo "    Pessoas:  ana@demo.local | bruno@demo.local | carla@demo.local"
echo "    Imóveis:  apt.centro@demo.local | casa.jardins@demo.local | kit.vila@demo.local"
echo "    Match + chat: Ana Silva ↔ Apto Centro"
echo ""
echo "  Backend API (outro terminal):"
echo "    ./scripts/runBackend.sh"
echo ""
echo "  App (simulador/desktop):"
echo "    flutter run --dart-define-from-file=dart_defines.json"
echo ""
echo "  App (emulador Android):"
echo "    flutter run --dart-define-from-file=dart_defines.android.json"
echo ""
if [[ -n "$LAN_IP" ]]; then
  echo "  App (celular físico — mesma Wi-Fi):"
  echo "    flutter run --dart-define-from-file=dart_defines.device.json"
  echo "    URL no celular: ${DEVICE_URL}"
  echo ""
fi
echo "  VS Code/Cursor: use a config 'aluga_comigo' (simulador) ou 'aluga_comigo (celular + Supabase local)'"
echo ""
