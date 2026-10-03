# swe-harness

A small engineering brain and harness for coding agents. One repo, installed once, used in any project with Claude Code or Codex.

The model does the engineering. This supplies what it cannot give itself: a habit of working a change through to the end, proof that the work is finished, a reviewer that did not write the code, and a place where the reasons outlive the session.

## How it fits together

```
CORE (installed by default)        swe-bootstrap  swe-change  swe-verify  swe-review  swe-debug

PROJECT KNOWLEDGE (kept, small)    AGENTS.md          operating rules, commands that were run
                                   docs/decisions/    significant or hard-to-reverse decisions
                                   docs/specs/        intended behaviour, only when useful
                                   docs/plans/        temporary, deleted when the work closes
                                   commit messages    why this implementation

DERIVED ON DEMAND (never stored)   repo structure, symbols, callers and dependencies, git history

OPTIONAL (installed by name)       browser/UI check, security audit, React and Next.js rules
```

Code, tests and git are the source of truth. The kept knowledge is only what they cannot explain.

## Core skills

| Skill | What it owns | Say |
|---|---|---|
| `swe-bootstrap` | Sets up a repository: a short `AGENTS.md` (every command run first), `CLAUDE.md` as `@AGENTS.md`, the decision-record format | "bootstrap this project" |
| `swe-change` | Any code change, start to finish: understand, design when there is a real choice, implement, verify, then keep what is worth keeping | "implement this", "fix this", "continue the work" |
| `swe-verify` | Done is an exit code: the check must pass after the last edit, and tests must not have been weakened | "is it done", "verify this" |
| `swe-review` | A fresh context that sees the diff and the requirements and tries to refute the change | "review this" |
| `swe-debug` | Hard bugs: reproduce with one command before theorising; stop after three failed fixes | "debug this" |

A small change through `swe-change` is just understand, edit, verify. Plans and specs are written only when the work needs them. At the end it asks what was learned that code, tests and git cannot cheaply give back, and files only that; "nothing worth keeping" is a normal answer.

## Optional skills

| Install key | Skill | From | Use it when |
|---|---|---|---|
| `browser` | `swe-browser-check` | this repo | Anything that renders in a browser changed |
| `security` | `swe-security-audit` | Cloudflare, fetched | A security question, or a full audit of a codebase |
| `react` | `swe-react` | Vercel, fetched | Writing or reviewing React or Next.js code |

Fetched skills are not stored here. `optional/sources` pins each to one upstream commit and records its licence; `install.sh` downloads exactly that commit, only when asked, and writes a `SOURCE` file into the installed folder. To update one, read the upstream diff and change the commit in `optional/sources`.

## Scripts

| Script | What it does |
|---|---|
| `swe-verify/scripts/verified` | Runs a check and records it as passed only on exit 0 |
| `swe-verify/scripts/test-guard` | Flags deleted or skipped tests, silenced checkers, removed assertions |
| `swe-review/scripts/review-package` | Writes the diff under review to one file for the reviewer |
| `swe-bootstrap/scripts/detect-stack` | Lists the stack, workspaces, build tools and candidate check commands from manifest files |

They need bash, git and awk. Scratch output goes to `.swe/` in the project, which ignores itself.

## Install

```bash
git clone https://github.com/Crypto-Gi/swe-harness && cd swe-harness
./install.sh                    # core only; no network needed
./install.sh browser            # core + browser check
./install.sh security react     # core + fetched specialist skills
./install.sh all
```

Skills are copied to `~/.claude/skills` and `~/.agents/skills`. Restart the agent afterwards. Update: `git pull`, run it again.

`swe-security-audit` needs Node for its validators. `swe-browser-check` needs a browser tool in the session (Playwright, Chrome DevTools MCP, or the app's own browser).

## Not included, on purpose

- Hooks. A stop hook that runs the project's check is a reasonable per-agent add-on; nothing here depends on one.
- Language packs. A language needs its check commands in `AGENTS.md`, which bootstrap finds and runs.
- A stored map, index, graph or wiki of the code.
- Tiers, phase gates, a task tracker, personas or agent teams.
- A spec framework. A spec here is a requirement and its scenarios.

## Checking this repo

```bash
./check             # skill lint and script tests, offline
./check --network   # also fetches the pinned optional skills into a throwaway HOME
```

## Licence

Apache-2.0 (`LICENSE`). Borrowed material keeps its own licence; see `SOURCES.md`.
