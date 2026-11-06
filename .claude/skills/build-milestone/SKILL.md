---
name: build-milestone
description: Build one milestone from docs/SPEC.md end to end with the planner, builder, tester and reviewer agents, stopping for human approval. Use when the user says "build M1", "next milestone", or similar.
---

# Build a milestone

Argument: the milestone id (e.g. `M1`). If none is given, pick the first milestone in docs/SPEC.md not marked done.

1. **Check the gate.** The spec must be marked `Status: Approved`. If not, stop and ask the user to approve it.
2. **Branch.** `git switch -c m<N>-<short-name>` (or use a worktree if another milestone is in progress).
3. **Plan.** Run the `planner` agent on the milestone. Show the plan to the user in a short summary. If it lists open questions, ask them before building.
4. **Build.** Run the `builder` agent with the plan.
5. **Test.** Run the `tester` agent. If it reports failing tests (bugs found), send them back to the `builder`. Repeat at most twice, then escalate to the user.
6. **Verify.** Run `npm run typecheck && npm run lint && npm test && npm run build` yourself and confirm they pass.
7. **Review.** Run the `reviewer` agent. Fix 🔴 items via the builder, then re-review.
8. **Human gate.** Stop and give the user:
   - what was built, mapped to each acceptance criterion
   - the reviewer's "worth a human look" list
   - how to try it manually (load unpacked from `dist/`)
   Don't commit or merge until the user approves.
9. On approval: commit, mark the milestone done in docs/SPEC.md, and append a few lines to `docs/case-study-notes.md` (problem solved, hard parts, decisions). These notes become the portfolio case study.
