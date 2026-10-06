# Changelog

## Unreleased
- `swe-review` runs only when the user explicitly asks. It is no longer started for risky changes, by `swe-change`, `swe-verify`, the pointer or the AGENTS template, and instructions like "always test and double-check" do not start it. For a change touching security, money or data that could be lost, the final message carries one line saying a review is available; otherwise review is not mentioned. Sonnet 5.5: a security fix with that instruction cost $0.37-0.44 with no review (was $0.69-0.96 with the automatic one; plain Sonnet $0.37), 22/22 on the hidden checks either way.
- A plain review request runs one reviewer; "thorough review" adds Claude Code's built-in `code-review`.
- `eval/run` fails if a review starts unasked or a plain review runs two reviewers. Sonnet 5.5: 30 of 30.
- The AGENTS template and `instructions.md` carry the outside-rule behaviour too (find out why before changing deliberate behaviour; ask when the reason is a rule from outside the code; record it with a comment at the code), so agents without the skills get it. `./check` keeps that phrase in step between the two. README: the knowledge table, diagram and `swe-change` row describe it, and the Codex note says to re-run `./install.sh` if Codex is set up later.

- `swe-bootstrap` looks at every doc and notes file before writing anything: a new `list-docs` script lists `.md`, `.txt`, `.rst`, `.adoc`, `.org` and extensionless notes with their first line, plus the agent and memory files in parent folders, names PDFs and office files without opening them, names secret files without ever reading them, and skips vendored, generated and test-data folders. Bootstrap reads decision records wherever they live, architecture, operator and contributing guides and parent rules in full, points `AGENTS.md` at them in a new "Read before changing" section instead of copying them, does not create a second decision home, asks only about decisions not already recorded, and reports which docs it read, skimmed or only named. From a real run that asked about decisions already in the repo and created a second decision folder. Sonnet 5.5, test project shaped like that repo: old bootstrap 11-12 of 14 checks (never pointed at the parent customer rules, never reported coverage, 2 of 4 runs created a second decision folder); new bootstrap 14 of 14 on every complete run, at the same cost.

- `list-docs` works on macOS's bash 3.2: it crashed at the end when a repo had no PDF, office or secret files, because bash before 4.4 treats an empty array as unbound under `set -u`. Lists now go through temporary files, and it no longer needs `sort -z`. Found in a real run on a Mac.

## 0.6.0 (2026-10-04)
From A/B trials in isolated Sonnet 5.5 sessions (plain versus harness, hidden graders).
- `install.sh` merges `pointer.md`, four lines naming when each skill applies, into `~/.claude/CLAUDE.md` and (if present) `~/.codex/AGENTS.md`; `uninstall` removes only that block. Sonnet 5.5 trials: skills fired on 7 of 11 prompts without it, 11 of 11 with it, and not on a plain question either way.
- `swe-change` finds out why before changing behaviour that looks deliberate, and stops to ask when the reason is a rule from outside the code. Such rules are recorded with a comment at the code that enforces them. Trial: asked a week later to "simplify" an accountant's per-line rounding rule, plain Sonnet undid it 3 of 3 times; with these changes 0 of 3, each stopping to quote the rule.
- Decision records: a rule from outside the code (a ruling, regulation, contract) qualifies on its own.
- A new test must fail on its assertion, not on an import of code that does not exist yet.
- `eval/run` installs the way `install.sh` does (user-level skills plus the pointer, in a private config folder per session), adds a one-line-rename task and a two-session outside-rule task, and `EVAL_ARM=without` runs the same tasks as a baseline. Sonnet 5.5: 27 of 27 checks with the harness; 13 of 27 without, including no regression test for the bug fix and the outside rule undone without asking.
- `swe-review` ranks findings by three stated facts (reach, silent or loud, damage) into FIX NOW, FIX IF SMALL or NOTE, instead of Critical/Important/Minor. A silent wrong result on valid input is always FIX NOW; FIX NOW needs a concrete trigger input; the author can change a tier only by disproving a fact with evidence; an open FIX NOW leads the final message. Built-in `code-review` is a named step in Claude Code. From a trial where a silent misparse was left as "minor" and `/code-review` was skipped.

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
