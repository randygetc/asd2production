#!/usr/bin/env bash
set -euo pipefail
BASE="${BASE_REF:-origin/main}"
changed="$(git diff --name-only --diff-filter=MDR "$BASE"...HEAD -- supabase/migrations 2>/dev/null || true)"
if [ -n "$changed" ]; then
  echo "Committed migrations are append-only (ADR-0005). Add a new migration instead:" >&2
  echo "$changed" >&2
  exit 1
fi
