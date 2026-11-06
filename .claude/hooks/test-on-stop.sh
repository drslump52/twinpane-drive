#!/usr/bin/env bash
# Stop hook: run unit tests when source or tests changed this session.
# Exit 2 blocks the stop and hands the failures back to Claude.
set -uo pipefail

input=$(cat)
# Avoid loops: if we already blocked once, let Claude stop.
[[ "$(jq -r '.stop_hook_active // false' <<<"$input")" == "true" ]] && exit 0

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
[[ -f package.json && -d node_modules ]] || exit 0
jq -e '.scripts.test' package.json >/dev/null 2>&1 || exit 0

# Only run when there are uncommitted changes to code or tests.
changed=$(git status --porcelain -- src tests 2>/dev/null)
[[ -z "$changed" ]] && exit 0

if ! out=$(npm test --silent 2>&1); then
  echo "Unit tests are failing. Fix them before finishing:" >&2
  echo "$out" | tail -n 60 >&2
  exit 2
fi
exit 0
