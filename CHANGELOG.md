# Changelog

## 0.5.0 (2026-10-04)
Changes from trials with Sonnet 5.5 on a small Python project and on a two-service FastAPI/MCP repository.
- `swe-change` description now fires on plain bug reports even before a repo is bootstrapped (before: no skill fired).
- `swe-change` runs verification itself: `verified`, `test-guard`, and a failing test before a bug fix (before: agents ran tests their own way and skipped both scripts). When the full check cannot run, it still runs the guard and records what it did run.
- `swe-change` asks for review on changes to accepted input, concurrency or shared state, and treats "make it faster" without a measurement as an idea to shape, not a change to make.
- `swe-review` runs both `/code-review` and its own reviewer in Claude Code, and the author no longer reads the diff before the reviewer reports.
- `swe-bootstrap` keeps counts, timings and known bugs out of `AGENTS.md`, records the direct command when a make target hides failures, and warns that private mode needs permission to write in `.git/`.
- Installing packages or creating environments outside the repo is a stop-and-ask action.
- `install.sh version` and `install.sh uninstall`; installed skills carry a version stamp.
- `eval/`: a repeatable trial suite run against real agent sessions.
- Script fixes: `test-guard` handles file names with spaces and non-ASCII; `verified` reports a repo with no commits correctly.

## 0.4.0 (2026-10-03)
- Uses Claude Code built-ins where they already do the job (`/code-review`, `/verify`, `/run`); install notes for Devin Desktop (formerly Windsurf) and Devin CLI.
- `instructions.md` paste-in custom instructions; Karpathy-style surgical-change and scope rules.

## 0.3.0 (2026-10-03)
- `swe-change` with close-out and commit steps; specs and plans only when useful; README updated at commit time.
- Optional specialist skills fetched on request at pinned commits; default install is core only, offline.

## 0.2.0 (2026-10-03)
- README for each agent app, zips for Claude desktop, CI check.

## 0.1.0 (2026-10-03)
- First version: `swe-bootstrap`, `swe-verify`, `swe-review`, `swe-debug`, scripts and tests.
