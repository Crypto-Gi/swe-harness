# swe-harness

A small set of Agent Skills that put engineering discipline around a strong coding model. One repo, installed once, used in any project with Claude Code or Codex.

The idea: the model does the engineering. This gives it three things it cannot supply itself: proof that work is finished, a reviewer that did not write the code, and a place where decisions outlive the session.

## What a project gets

Say "bootstrap this project" in a repository. It writes three files and nothing else:

- `AGENTS.md`: under 100 lines. The check commands (each one run first), conventions that differ from the defaults, when to stop and ask, and pointers to the skills.
- `CLAUDE.md`: one line, `@AGENTS.md`, so both agents read the same file.
- `docs/decisions/README.md`: the format for one-paragraph decision records.

Code, tests and git stay the source of truth. Nothing about the code's structure is stored; agents look it up when they need it.

## Skills

### Core

| Skill | Use it when | Say |
|---|---|---|
| `swe-bootstrap` | Starting in a repository that has no `AGENTS.md`, or refreshing one | "bootstrap this project" |
| `swe-verify` | Before saying work is done; when writing tests | "is it done", "verify this" |
| `swe-review` | A change is risky, hard to reverse, or too big to read at once | "review this" |
| `swe-debug` | A bug survives one fix, a flaky test, a slowdown | "debug this" |

### Optional

Loaded only when a task needs them.

| Skill | Use it when |
|---|---|
| `swe-browser-check` | Anything that renders in a browser changed |
| `swe-security-audit` | A security question, or a full audit of a codebase (from Cloudflare) |
| `swe-react` | Writing or reviewing React or Next.js code (from Vercel) |

## Scripts

| Script | What it does |
|---|---|
| `swe-verify/scripts/verified` | Runs a check and records it as passed only on exit 0 |
| `swe-verify/scripts/test-guard` | Flags deleted or skipped tests, silenced checkers, removed assertions |
| `swe-review/scripts/review-package` | Writes the diff under review to one file for the reviewer |
| `swe-bootstrap/scripts/detect-stack` | Lists the stack and candidate check commands from manifest files |

They need bash, git and awk. Scratch output goes to `.swe/` in the project, which ignores itself.

## Install

```bash
git clone <this repo> && cd swe-harness
./install.sh            # copies skills to ~/.claude/skills and ~/.agents/skills
./install.sh core       # core four only
```

Restart the agent afterwards. Update: `git pull`, run it again.

`swe-security-audit` needs Node to run its validators. `swe-browser-check` needs a browser tool in the session (Playwright, Chrome DevTools MCP, or the app's own browser).

## Not included, on purpose

- Hooks. A stop hook that runs the project's check is a reasonable per-agent add-on; it is not required for anything here to work.
- Language packs. A language needs its check commands in `AGENTS.md`, which bootstrap finds and runs.
- A stored map, index or graph of the code.
- Routing rules, tiers, a task tracker, personas or agent teams.

## Checking this repo

```bash
./check
```

## Licence

MIT (`LICENSE`). Borrowed material keeps its own licence; see `SOURCES.md`.
