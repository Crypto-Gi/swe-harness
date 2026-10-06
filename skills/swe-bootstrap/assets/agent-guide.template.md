# {{PROJECT}}: agent guide

What an agent needs to know to work in this repository. Written and refreshed by `swe-bootstrap`; your own instructions belong in `AGENTS.md`.

{{ONE_OR_TWO_LINES: what this is and who uses it}}

## Commands
Each was run on {{DATE}}. No counts, timings or known bugs here: they change with every commit.
- Full check (must pass before work is done): `{{CHECK}}`
- Fast check while working: `{{CHECK_FAST}}`
- Run locally: `{{RUN}}`

## Conventions that differ from the defaults
{{Only what an agent would get wrong and no linter enforces. Delete this section if empty.}}

## Read before changing
{{One line per area: the existing doc or parent-folder rules to read first, e.g. `docs/ARCHITECTURE.md` before changing the planner. Point, never copy. Delete this section if the repo has no such docs.}}

## Where knowledge lives
- This file: commands that were run, conventions, and where to read before changing what.
- `{{DECISIONS: docs/decisions/, or wherever this repo already keeps them}}`: significant or hard-to-reverse decisions, and any rule from outside the code, with why. Such a rule also gets a one-line comment where the code enforces it. Read the entries for the area you touch; never silently contradict one.
- `docs/specs/`: intended behaviour worth stating apart from the code. Created only when a change needs it.
- `docs/plans/`: temporary, for multi-session work; deleted when the work closes.
- Commit messages: why this implementation. Code, tests and git: everything else. Do not write down what can be looked up.

## Use when the task calls for it
{{Keep only the lines this stack needs. Delete this section if none.}}
- Change to anything that renders in a browser: `swe-browser-check`
- React or Next.js code: `swe-react`
- Security audit or security question about this code: `swe-security-audit`
If one is not installed, say so and name the command (`./install.sh browser|react|security` in swe-harness); do not install it yourself.

## Private notes
If `docs/private/README.md` exists, read it. It is never committed.
