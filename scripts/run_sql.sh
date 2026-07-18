#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

if ! command -v duckdb >/dev/null 2>&1; then
  echo "DuckDB CLI was not found. Install DuckDB 1.5.x and ensure duckdb is on PATH." >&2
  exit 1
fi

mkdir -p outputs/sql
duckdb road_safety.duckdb -c ".read sql/run_all.sql"
