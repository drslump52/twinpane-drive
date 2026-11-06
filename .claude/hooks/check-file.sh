#!/usr/bin/env bash
# PostToolUse hook (Edit|Write): typecheck after a TypeScript/JS source edit.
# Exit 2 sends the errors back to Claude so it fixes them before moving on.
set -uo pipefail

f=$(jq -r '.tool_input.file_path // .tool_response.filePath // empty')
[[ -z "$f" ]] && exit 0
[[ "$f" =~ \.(ts|tsx|js|jsx|mts)$ ]] || exit 0

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
[[ -f package.json && -d node_modules ]] || exit 0
jq -e '.scripts.typecheck' package.json >/dev/null 2>&1 || exit 0

if ! out=$(npm run -s typecheck 2>&1); then
  echo "Typecheck failed after editing $f:" >&2
  echo "$out" | tail -n 40 >&2
  exit 2
fi
exit 0
