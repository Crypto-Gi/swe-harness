---
name: swe-change
description: The way to make any code change in a repository, including one-line fixes. Use it whenever the user reports a bug, pastes an error or stack trace, or asks to fix, implement, add, build, change, refactor, migrate, upgrade or remove something in code, or says "continue the work". Use it even when the fix looks obvious: it is what makes the change tested, verified and recorded instead of a quick unverified edit.
---

# Change

How a change gets from request to finished. Do what this change needs and no more: a small one is understand, edit, verify, done. Nothing here has to be announced, and no step produces a document unless it says so.

## Understand
- Read `AGENTS.md` and `agent-guide.md`. Read the `docs/decisions/` and `docs/specs/` entries for the area you will touch, if any exist. If a plan for this work exists in `docs/plans/`, continue from it.
- Learn how it works today from the code itself: search, read the callers and the tests. Look structure up when you need it; do not write it down.
- Before changing or removing behaviour that looks deliberate (a test pins it, a comment, commit message or decision record explains it), find out why: `git log -L <start>,<end>:<file>` or `git blame` on those lines, and the decision records. A request to simplify or clean up is not a decision to drop a rule. If the reason is a requirement from outside the code (someone's ruling, a regulation, a contract, a promise to customers), stop and ask before changing it, and quote the reason and where you found it: the person asking may not know the rule exists. Otherwise go ahead, and say in your final message what you reversed and why it had existed.
- Ask the user only what the repository cannot answer and what changes the result. If the request can be read more than one way, say which reading you are taking; stop to ask only when a wrong guess would be costly.
- Know what done looks like before editing: for a bug, the failing case and the expected result; for a feature, the behaviour someone can observe; for a refactor, the behaviour that must not change; for "make it faster", a measurement before and after. If you cannot say what done looks like, or cannot measure, treat the request as a new idea: shape it, propose, and change nothing yet.
- Note the current commit (`git rev-parse HEAD`) before editing; review and close-out use it.

## Design, when there is a real choice
- **A new or vague idea** (a new project, a new feature area, "I want something that..."): shape it before choosing anything. List the open questions as a tree: some can only be asked once others are answered. Ask every question that is answerable now in one numbered round, each with your recommended answer, then recompute and ask the next round. Look up facts in the repository or docs yourself; ask the user only for decisions and intent. It is shaped when no open question remains; write back your understanding and build nothing until the user confirms it.
- Name the options and pick one, with the reason, in a few lines. A hard-to-reverse choice is confirmed with the user before you build on it. The stop conditions in `AGENTS.md` apply throughout.
- **Plan file** only when the work will not finish in one session or the approach is uncertain enough that the user should see it before code exists. One file, `docs/plans/<slug>.md`, shape in `references/formats.md`.
- **Spec** only when intended behaviour, acceptance criteria or behaviour across components matters enough that a future engineer could not reliably recover it from the code and tests. Being user-visible is not enough on its own. Shape in `references/formats.md`. If a spec already covers what you are changing, update it in the same change.

## Implement
- Small steps, with the fast check from `agent-guide.md` after each. Tests ship with the change.
- If the work turns out larger or different than you understood, say so before continuing.
- A bug that survives one fix attempt: `swe-debug`.

## Verify
Do this yourself, every time, before saying the work is done. Running the tests your own way is not the same: the recorder makes "done" a fact anyone can check, and the guard catches the quiet ways a check gets made to pass. The scripts are in the `swe-verify` skill folder installed next to this one (`<skills dir>/swe-verify/scripts/`).
1. Run the full check from `agent-guide.md` through the recorder, after your last edit: `bash <skills dir>/swe-verify/scripts/verified <label> -- <check command>`. Non-zero means not done.
2. Run `bash <skills dir>/swe-verify/scripts/test-guard`. Fix what it flags, or say why the flagged line is the requested change. Removed assertions that pinned deliberate behaviour count as requested only after the check in Understand on why that behaviour existed. The guard only reads git, so it runs even when the tests cannot.
   If the full check cannot run here (missing dependencies, no network), do not skip verification: run what you can (the new test on its own, a compile, the linter) through `verified` with a label that says what it was, such as `verified new-test-only -- ...`, and say plainly that the full check did not run.
3. A bug fix or a behaviour change: show the new test failing without the change (run it before changing the code, or revert, run, restore). The test is what proves the change, so a test you never saw fail proves nothing. It must fail on its assertion, not on an import or a name that does not exist yet, so write it against the interface that already exists.
4. Do not start `swe-review`; reviews run only when the user asks for one. If the change touches security, money or data that could be lost, end the final message with one line saying so and that a review is available. Say nothing about review otherwise.

Writing or changing tests, or anything unusual about verification: read `swe-verify`.

## Close out
Ask: **what did we learn here that a future engineer or agent cannot cheaply recover from the code, tests and git?** Promote only that, each piece to one place:

| What was learned | Where it goes |
|---|---|
| A rule the code must follow because of something outside it (someone's ruling, a regulation, a contract), with its reason | `docs/decisions/` (start the folder from `swe-bootstrap/assets/decisions-README.md` if it is missing), plus a one-line comment at the code that enforces it, naming the record. A later cleanup will undo a rule nobody can see. |
| A significant trade-off or hard-to-reverse decision | `docs/decisions/` |
| Durable intended behaviour or an acceptance contract | `docs/specs/` |
| A repo convention, or a check command that changed and was re-run | `agent-guide.md`. `AGENTS.md` is the user's: never write project facts there |
| Why this implementation is the way it is | the commit message |
| Anything derivable from the code, exploration, session notes | nowhere |

- "Nothing worth keeping" is a valid answer. Say it in one line and move on.
- If the change contradicts an existing decision, spec or `agent-guide.md` line, fix that entry now: supersede the decision, update the spec, correct the line.
- A decision record states what the user decided or confirmed. Your own unconfirmed reasoning goes in the commit message.
- Delete the plan file once its durable parts are promoted. Do not keep plans, notes or transcripts as history; git has the history.

## Commit
Commit when the user asks, or when `AGENTS.md` or `agent-guide.md` says this project commits as it goes. Never before the change is verified.
- **README and user docs, at commit time and not before.** If this change made the README or other user-facing docs wrong or incomplete (install, usage, configuration, commands, features), update them in this same commit. Do not update them while the code is still changing, and do not touch them for changes a user would not notice.
- Stage the files you mean to commit by name, and read `git diff --staged` first. Never commit secrets, `.env` files, local config or build output.
- One logical change per commit. Unrelated fixes you noticed go in their own commit, or are left for the user.
- Message: a short summary line, then why: the problem, the cause for a bug, and anything a reviewer must know. Follow the project's convention if it has one.
- Work on the branch the user is on, unless `AGENTS.md` or the user says otherwise. Do not push, amend pushed commits, rebase shared branches or force push without being asked.

Final message: the reading you took, what changed, the `verified:` line the recorder printed, what was promoted and where (or that nothing was), every `Ruling:`, and the remaining risk or anything left undone. A one-line change gets a one-line answer.
