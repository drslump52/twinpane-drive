# Spec: Drive two-panel manager

**Status: Approved** (2026-11-05)
**Name:** TwinPane for Google Drive · repo `twinpane-drive`

## 1. Problem
Reorganizing a Google Drive in the web UI is slow: one folder view, clumsy drag targets, no copy for folders. Third-party organizers need full Drive access and route it through someone else's code or servers. Users who care about privacy have no good option.

## 2. Goal
A free, open-source Chrome extension that gives a fast two-panel view of Google Drive, with drag-and-drop and keyboard-driven move and copy, and **no backend**: the user's token and data stay in their browser.

## 3. Users
- Primary: people with large, messy Drives (freelancers, small teams) who reorganize often.
- Secondary (portfolio): clients evaluating the developer, so it must look polished and be easy to demo.

## 4. Scope v1 (MVP)
### Access
- Sign in with `chrome.identity.getAuthToken`, scope `https://www.googleapis.com/auth/drive`.
- Sign out (revoke the cached token).
- **Demo mode**: runs against `FakeDrive` sample data, without signing in. Used for the portfolio demo, screenshots and e2e tests.

### Layout
- Opens in a full browser tab when the toolbar icon is clicked.
- Two panels side by side; one is active (highlighted).
- Each panel: root selector (My Drive · Shared drives · Shared with me) → breadcrumb → file list.
- File list columns: icon, name, size, modified date. Folders first, sortable by column.
- Status bar: selected count and total size.

### Navigation & selection
- Double-click / Enter opens a folder; Backspace / breadcrumb goes up.
- Click, Shift-click (range), Cmd/Ctrl-click (toggle), Cmd/Ctrl-A.
- Keyboard: Tab switches panel, arrows move the cursor, Space toggles selection.

### Operations
| Action | Mouse | Key |
|---|---|---|
| Move selection to other panel's folder | drag & drop | F6 |
| Copy selection to other panel's folder | Option/Alt + drag | F5 |
| New folder | toolbar | F7 |
| Rename | toolbar | F2 |
| Move to trash | toolbar | F8 / Delete |
| Refresh | toolbar | Cmd/Ctrl-R in-app |

- **Move** = `files.update` with `addParents`/`removeParents` (metadata only, instant).
- **Copy file** = `files.copy`. **Copy folder** = recreate the tree, then copy files (the API has no folder copy).
- Confirm dialog for every operation: shows item count and destination.
- **Conflicts** (same name exists in destination): ask: Skip · Keep both (append " (1)") · Apply to all. No overwrite in v1.
- Block moving a folder into itself or its descendant.
- Moves into/out of shared drives: warn that ownership/permissions change.

### Operations queue
- Every operation is a job in a queue panel: progress (n/total), current item, cancel, retry failed items.
- Concurrency limit (default 4) and exponential backoff on 429 / 403 `rateLimitExceeded` / 5xx.
- On partial failure: list failed items with reasons. Never silently drop items.

## 5. Out of scope (v1)
Upload/download to the local computer · editing sharing permissions · file preview · search (candidate for v1.1) · permanent delete · offline mode · other browsers than Chrome.

## 6. Non-functional
- **Security/privacy:** no backend, no analytics, no third-party requests; only `googleapis.com`. Manifest permissions: `identity`, `storage` only. Default MV3 CSP. Token never logged or stored by our code. Open source (MIT).
- **Performance:** listing pages of 1000 items via `pageSize` + `nextPageToken`; UI stays responsive with 5,000 items in a folder (virtualized list).
- **Quality:** strict TypeScript; unit tests for all of `src/ops/` against `FakeDrive`; CI runs typecheck, lint, test and build.
- **Accessibility:** fully keyboard operable; visible focus; light and dark theme following the system.

## 7. Milestones & acceptance criteria
| ID | Milestone | Done when |
|---|---|---|
| **M0** | Scaffold | Vite + React + TS builds a loadable MV3 extension; icon opens app tab; typecheck/lint/test/build scripts + CI workflow pass; hooks verified. |
| **M1** | Auth + API client + FakeDrive | Sign in/out works with a real account; `DriveClient` (list, get, update parents, copy, create folder, rename, trash) with backoff; `FakeDrive` passes the same contract tests. |
| **M2** | Single panel browsing | Root selector, breadcrumb, sorted list, pagination, folder navigation; demo mode works. |
| **M3** | Two panels + selection + keyboard | All selection and navigation shortcuts in §4 work in both panels. |
| **M4** | Move | Drag-and-drop and F6 move with confirm, self-descendant guard, shared-drive warning, conflict dialog. |
| **M5** | Copy + queue | F5 / Alt-drag copy incl. recursive folders; queue with progress, cancel, retry, backoff; partial failures reported. |
| **M6** | Folder ops | New folder, rename, trash. |
| **M7** | Polish & ship | Dark mode, empty/error states, virtualized list, README, demo GIF, Web Store listing draft, case study. |

## 8. Decisions (2026-11-05)
1. **Name:** TwinPane for Google Drive. ("for Google Drive" is descriptive; never imply it's made by Google.)
2. **Default drag action:** Move; Option/Alt-drag copies.
3. **UI framework:** React.
4. **Publishing:** publish to the Chrome Web Store in M7, including Google OAuth verification for the `drive` scope. M7 adds a privacy policy page and the verification demo video.
5. **Repo:** public on GitHub from the start (MIT).
