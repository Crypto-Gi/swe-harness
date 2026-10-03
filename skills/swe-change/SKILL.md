---
name: swe-change
description: The normal way to make any code change in a project, from a one-line fix to a multi-session feature. Use when the user asks to implement, add, build, change, fix, refactor, migrate, upgrade or remove something in code, or says "implement this feature", "make this change", "continue the work" or "pick up where we left off".
---

# Change

How a change gets from request to finished. Do what this change needs and no more: a small one is understand, edit, verify, done. Nothing here has to be announced, and no step produces a document unless it says so.

## Understand
- Read `AGENTS.md`. Read the `docs/decisions/` and `docs/specs/` entries for the area you will touch, if any exist. If a plan for this work exists in `docs/plans/`, continue from it.
- Learn how it works today from the code itself: search, read the callers and the tests, use `git log` and `git blame` for why. Look structure up when you need it; do not write it down.
- Ask the user only what the repository cannot answer and what changes the result. If the request can be read more than one way, say which reading you are taking; stop to ask only when a wrong guess would be costly.
- Know what done looks like before editing: for a bug, the failing case and the expected result; for a feature, the behaviour someone can observe; for a refactor, the behaviour that must not change.
- Note the current commit (`git rev-parse HEAD`) before editing; review and close-out use it.

## Design, when there is a real choice
- **A new or vague idea** (a new project, a new feature area, "I want something that..."): shape it before choosing anything. List the open questions as a tree: some can only be asked once others are answered. Ask every question that is answerable now in one numbered round, each with your recommended answer, then recompute and ask the next round. Look up facts in the repository or docs yourself; ask the user only for decisions and intent. It is shaped when no open question remains; write back your understanding and build nothing until the user confirms it.
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

## Commit
Commit when the user asks, or when `AGENTS.md` says this project commits as it goes. Never before the change is verified.
- **README and user docs, at commit time and not before.** If this change made the README or other user-facing docs wrong or incomplete (install, usage, configuration, commands, features), update them in this same commit. Do not update them while the code is still changing, and do not touch them for changes a user would not notice.
- Stage the files you mean to commit by name, and read `git diff --staged` first. Never commit secrets, `.env` files, local config or build output.
- One logical change per commit. Unrelated fixes you noticed go in their own commit, or are left for the user.
- Message: a short summary line, then why: the problem, the cause for a bug, and anything a reviewer must know. Follow the project's convention if it has one.
- Work on the branch the user is on, unless `AGENTS.md` or the user says otherwise. Do not push, amend pushed commits, rebase shared branches or force push without being asked.

Final message: the reading you took, what changed, the `verified:` line, what was promoted and where (or that nothing was), every `Ruling:`, and the remaining risk or anything left undone. A one-line change gets a one-line answer.
