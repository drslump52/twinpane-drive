# TwinPane for Google Drive

A two-panel file manager for Google Drive, as a Chrome extension. Move and copy files and folders between panels with drag-and-drop or the keyboard.

**Private by design:** no backend, no analytics. The extension talks only to Google's Drive API, and your sign-in token never leaves your browser.

> 🚧 In development. See the [spec](docs/SPEC.md) for scope and milestones.

## Planned features
- Two side-by-side panels: My Drive, shared drives, Shared with me
- Drag to move, Option/Alt-drag to copy, plus F5/F6/F7/F8 shortcuts
- Recursive folder copy (which Google Drive's own UI can't do)
- Operation queue with progress, cancel, retry and rate-limit handling
- Conflict handling: skip, keep both, apply to all
- Demo mode with sample data, no sign-in needed

## How it's built
TypeScript, React, Vite, Manifest V3. Every operation is unit-tested against an in-memory fake Drive.

Developed with an AI-assisted workflow: planner, builder, tester and reviewer agents (see [`.claude/`](.claude/)), with human review of the spec and of every milestone.

## License
[MIT](LICENSE)
