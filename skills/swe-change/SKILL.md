---
name: swe-change
description: The normal way to make any code change in a project, from a one-line fix to a multi-session feature. Use when the user asks to implement, add, build, change, fix, refactor, migrate, upgrade or remove something in code, or says "implement this feature", "make this change", "continue the work" or "pick up where we left off".
---

# Change

How a change gets from request to finished. Do what this change needs and no more: a small one is understand, edit, verify, done. Nothing here has to be announced, and no step produces a document unless it says so.

## Understand
- Read `AGENTS.md`. Read the `docs/decisions/` and `docs/specs/` entries for the area you will touch, if any exist. If a plan for this work exists in `docs/plans/`, continue from it.
- Learn how it works today from the code itself: search, read the callers and the tests, use `git log` and `git blame` for why. Look structure up when you need it; do not write it down.
- Ask the user only what the repository cannot answer and what changes the result.
- Note the current commit (`git rev-parse HEAD`) before editing; review and close-out use it.

## Design, when there is a real choice
- Name the options and pick one, with the reason, in a few lines. A hard-to-reverse choice is confirmed with the user before you build on it. The stop conditions in `AGENTS.md` apply throughout.
- **Plan file** only when the work will not finish in one session or the approach is uncertain enough that the user should see it before code exists. One file, `docs/plans/<slug>.md`, shape in `references/formats.md`.
- **Spec** only when intended behaviour, acceptance criteria or behaviour across components matters enough that a future engineer could not reliably recover it from the code and tests. Being user-visible is not enough on its own. Shape in `references/formats.md`. If a spec already covers what you are changing, update it in the same change.

## Implement
- Small steps, with the fast check from `AGENTS.md` after each. Tests ship with the change.
- If the work turns out larger or different than you understood, say so before continuing.
- A bug that survives one fix attempt: `swe-debug`.

## Verify
- `swe-verify`, always.
- `swe-review` when the change is risky, hard to reverse, security-relevant or too large to read in one sitting.

## Close out
Ask: **what did we learn here that a future engineer or agent cannot cheaply recover from the code, tests and git?** Promote only that, each piece to one place:

| What was learned | Where it goes |
|---|---|
| A significant trade-off or hard-to-reverse decision | `docs/decisions/` |
| Durable intended behaviour or an acceptance contract | `docs/specs/` |
| An operating rule, or a command that changed and was re-run | `AGENTS.md` |
| Why this implementation is the way it is | the commit message |
| Anything derivable from the code, exploration, session notes | nowhere |

- "Nothing worth keeping" is a valid answer. Say it in one line and move on.
- If the change contradicts an existing decision, spec or `AGENTS.md` line, fix that entry now: supersede the decision, update the spec, correct the line.
- A decision record states what the user decided or confirmed. Your own unconfirmed reasoning goes in the commit message.
- Delete the plan file once its durable parts are promoted. Do not keep plans, notes or transcripts as history; git has the history.
- The commit message says what changed and why.

Final message: what changed, the `verified:` line, what was promoted and where (or that nothing was), every `Ruling:`, and anything left undone.
