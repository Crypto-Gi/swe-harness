# swe-harness: repo guide

A lean engineering brain and harness for coding agents (Claude Code and Codex): a few skills, a few scripts, and a small amount of kept project knowledge. `README.md` says what each skill does and how to install. `SOURCES.md` says where each borrowed piece came from.

## Layout
- `skills/<name>/SKILL.md`: the core, one folder per skill, all prefixed `swe-`: `swe-bootstrap`, `swe-change`, `swe-verify`, `swe-review`, `swe-debug`. Long material in `references/`, scripts in `scripts/`, templates in `assets/`.
- `optional/`: specialist skills. Ours live here as folders (`swe-browser-check`). Other people's are one line each in `optional/sources` (repository, pinned commit, path, licence) and are fetched by `install.sh` on request.
- `tests/run`: self-tests for every script and for the installer.
- `check`: the full check for this repo. `./check --network` also fetches the pinned optional skills.
- `install.sh`: default installs the core with no network; optional skills by name. `./install.sh zip` rebuilds `zips/` (core + browser) for uploading to the Claude apps.
- `zips/`: committed, byte-reproducible. After changing a skill, run `./install.sh zip`; `./check` fails on a stale zip.
- `pointer.md`: the four lines `install.sh` merges into `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md` so the skills load; `uninstall` removes them.
- `instructions.md`: the same working rules as one paste-in block for app custom instructions. `./check` fails if its key phrases drift from the AGENTS template.
- `eval/`: real headless agent sessions on a fixture project with automatic checks (`eval/run`, costs usage). Run it before and after changing what a skill tells the agent.
- `VERSION`, `CHANGELOG.md`: bump the version and add a changelog entry with every release; tag it `v<version>`.
- `.github/workflows/check.yml`: runs `./check --network` on every push.

## Rules
- Run `./check` before saying a change is done. It must exit 0.
- Skill folder name = `name` in frontmatter. Frontmatter uses only `name` and `description` in skills we wrote, so they load in both agents.
- The `description` says when the skill fires: what it does plus the phrases a user would say. It never summarises the steps; an agent that reads a workflow in the description follows that and skips the body.
- Keep `SKILL.md` short: steps and rules. Write instructions, not explanations. For every line ask: would the agent get this wrong without it? If not, cut it.
- Deterministic work goes in a script with a test in `tests/run`. Skills call scripts as `bash scripts/<name>`.
- No always-on parts: no session hooks, no router skill, nothing a project must install to function. The one exception is `pointer.md`, four lines the installer puts in the user's instructions file, because without it the skills fired on 7 of 11 trial prompts. Keep it at four lines.
- The test for every addition: does it preserve important engineering knowledge that cannot be derived from code, tests and git, or give reliable feedback a strong model cannot give itself? If not, leave it out.
- `swe-change` stays a checklist, not a process: no tiers, gates, required documents or announcements. A small change must still read as understand, edit, verify.
- Kept project knowledge has five homes and no more: `AGENTS.md`, `docs/decisions/`, `docs/specs/`, temporary `docs/plans/`, commit messages. A rule from outside the code also gets a one-line comment where the code enforces it, because that is where the next editor looks. Nothing that can be looked up is stored.
- Borrowed text keeps its attribution line and a row in `SOURCES.md`.
- Other people's skill trees are never stored here. Add them to `optional/sources` pinned to a full commit; change a pin only after reading the upstream diff, and run `./check --network`.
- Never copy from sources whose licence forbids it (Anthropic's docx/pdf/pptx/xlsx skills) or requires share-alike (Trail of Bits, CC BY-SA).

## Changing this repo
- Make the smallest change that does the job. No speculative options, folders or config.
- A new rule in a skill should come from an observed failure, ideally one `eval/run` or a trial transcript shows. If a strong model already does it unprompted, leave it out.
- Explain why a rule exists in the skill text instead of shouting it: models follow a reason more reliably than a MUST.
- A new skill needs a row in the README table and a reason it cannot be a line in an existing one.
