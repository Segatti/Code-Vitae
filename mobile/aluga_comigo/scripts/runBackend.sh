#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BACKEND_DIR="$PROJECT_ROOT/backend"

run_supabase() {
  if command -v supabase >/dev/null 2>&1; then
    supabase "$@"
    return
  fi
  if command -v npx >/dev/null 2>&1; then
    npx --yes supabase@latest "$@"
    return
  fi
  return 1
}

cd "$BACKEND_DIR"

export PORT="${PORT:-8080}"
export DATABASE_URL="${DATABASE_URL:-postgresql://postgres:postgres@127.0.0.1:54322/postgres}"

if [[ -z "${SUPABASE_JWT_SECRET:-}" || -z "${SUPABASE_URL:-}" ]]; then
  env_output="$(cd "$PROJECT_ROOT" && run_supabase status -o env 2>/dev/null || true)"
  if [[ -n "$env_output" ]]; then
    if [[ -z "${SUPABASE_JWT_SECRET:-}" ]]; then
      SUPABASE_JWT_SECRET="$(echo "$env_output" | sed -n 's/^JWT_SECRET="\(.*\)"$/\1/p' | head -n 1)"
      export SUPABASE_JWT_SECRET
    fi
    if [[ -z "${SUPABASE_URL:-}" ]]; then
      SUPABASE_URL="$(echo "$env_output" | sed -n 's/^API_URL="\(.*\)"$/\1/p' | head -n 1)"
      export SUPABASE_URL
    fi
  fi
fi

export SUPABASE_JWT_SECRET="${SUPABASE_JWT_SECRET:-super-secret-jwt-token-with-at-least-32-characters-long}"
export SUPABASE_URL="${SUPABASE_URL:-http://127.0.0.1:54321}"

dart pub get
exec dart run bin/server.dart
