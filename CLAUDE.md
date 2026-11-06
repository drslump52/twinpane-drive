# Drive two-panel manager (Chrome extension)

A Manifest V3 Chrome extension that opens a full-tab, two-panel (orthodox file manager style) view of the user's Google Drive, for moving and copying files and folders between panels. No backend: everything runs in the browser and the OAuth token never leaves it.

Spec: `docs/SPEC.md` (source of truth). Google Cloud setup: `docs/SETUP-GOOGLE.md`.

## Stack
TypeScript (strict) · React · Vite · Vitest · Biome (lint + format) · Playwright (UI e2e, later)

## Commands
(Added in M0 — keep this list accurate.)
- `npm run dev`: build in watch mode to `dist/`; load unpacked in chrome://extensions
- `npm run build`: production build to `dist/`
- `npm run typecheck`: `tsc --noEmit`
- `npm run lint`: Biome check
- `npm test`: Vitest unit tests

## Architecture and boundaries
- `src/api/`: the only code that talks to the Drive REST API (v3, via `fetch`, no gapi). Exposes a `DriveClient` interface. Retries 429/403-rate-limit/5xx with exponential backoff.
- `src/api/fake/`: `FakeDrive`, an in-memory implementation of `DriveClient` for tests and the offline demo mode.
- `src/ops/`: pure operation logic (move, copy, recursive folder copy, conflict resolution, the job queue). Depends only on the `DriveClient` interface.
- `src/ui/`: React components and state. Never calls `fetch` directly.
- `src/background/`: the service worker (opens the app tab, nothing else unless the spec says so).

## Rules
- Never call the real Drive API in tests; use `FakeDrive`.
- Destructive actions go to **trash**, never permanent delete.
- Every Drive API call passes `supportsAllDrives=true` (and `includeItemsFromAllDrives=true` on list).
- Never log or persist the OAuth token. Use `chrome.identity.getAuthToken` only.
- No analytics, no third-party network calls, no remote code. Only `https://www.googleapis.com/*`.
- New dependencies need a reason in the PR or commit message.
- Logic in `src/ops/` must have unit tests covering the edge cases listed in `.claude/agents/tester.md`.

## Workflow
Use the `build-milestone` skill: planner → builder → tester → reviewer → **human approval** → commit. Never merge a milestone without the user's approval. Record decisions and hard parts in `docs/case-study-notes.md` as you go.
