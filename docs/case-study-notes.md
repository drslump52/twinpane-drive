# Case study notes

Running log of decisions and hard parts. The `case-study` skill turns this into the portfolio write-up.

## 2026-11-05: Setup
- Why build instead of using existing Drive organizers: they need the full `drive` scope, and some route data through their own servers. This tool has no backend, so the token stays in the browser.
- Built with an AI-assisted pipeline: planner → builder → tester → reviewer agents, with human approval of the spec and of every milestone.
