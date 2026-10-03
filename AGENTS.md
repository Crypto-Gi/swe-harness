# swe-harness: repo guide

Agent Skills for software engineering with Claude Code and Codex. `README.md` says what each skill does and how to install. `SOURCES.md` says where each borrowed piece came from.

## Layout
- `skills/<name>/SKILL.md`: one folder per skill, all prefixed `swe-`. Long material in `references/`, scripts in `scripts/`, templates in `assets/`.
- Core: `swe-bootstrap`, `swe-verify`, `swe-review`, `swe-debug`. Optional: `swe-browser-check`, `swe-security-audit`, `swe-react`.
- `tests/run`: self-tests for every script.
- `check`: the full check for this repo (skill lint, script tests, upstream validator tests).
- `install.sh`: copies skills to `~/.claude/skills` and `~/.agents/skills`.

## Rules
- Run `./check` before saying a change is done. It must exit 0.
- Skill folder name = `name` in frontmatter. Frontmatter uses only `name` and `description` in skills we wrote, so they load in both agents.
- The `description` says when the skill fires: what it does plus the phrases a user would say. It never summarises the steps; an agent that reads a workflow in the description follows that and skips the body.
- Keep `SKILL.md` short: steps and rules. Write instructions, not explanations. For every line ask: would the agent get this wrong without it? If not, cut it.
- Deterministic work goes in a script with a test in `tests/run`. Skills call scripts as `bash scripts/<name>`.
- No always-on parts: no session hooks, no router skill, nothing a project must install to function.
- Borrowed text keeps its attribution line and a row in `SOURCES.md`. `swe-security-audit` and `swe-react` are upstream copies: change them only when needed and note the change in `SOURCES.md`.
- Never copy from sources whose licence forbids it (Anthropic's docx/pdf/pptx/xlsx skills) or requires share-alike (Trail of Bits, CC BY-SA).

## Changing this repo
- Make the smallest change that does the job. No speculative options, folders or config.
- A new rule in a skill should come from an observed failure. If a strong model already does it unprompted, leave it out.
- A new skill needs a row in the README table and a reason it cannot be a line in an existing one.
