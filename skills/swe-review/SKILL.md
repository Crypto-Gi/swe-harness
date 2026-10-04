---
name: swe-review
description: Independent review of a code change by a fresh context that tries to refute it. Use when the user says "review this", "review my changes", "check this before I merge", "second opinion", or before finishing a change that is risky, hard to reverse, security-relevant, or too large to read in one sitting. Also use to re-check after review findings were fixed.
---

# Review

The author of a change cannot review it: the same context that wrote the bug explains it away. This skill hands the change to a reviewer that sees only the diff and the requirements.

Terms: a **subagent** is whatever your platform uses to run a task in a fresh context (Task/Agent tool in Claude Code, spawn_agent in Codex). If none exists, or the user wants a second model, write the filled prompt to `.swe/review-prompt.md` and ask the user to run it in a new session or another agent, then paste the result back. Say which path you used.

## Steps
1. **Requirements.** Collect what the change was supposed to do: the user's request in their words, the plan or spec file if one exists, and the `docs/decisions/` entries for the touched area. If you cannot state the requirements, ask before reviewing.
2. **Package the diff.** `bash scripts/review-package <BASE> [HEAD]`, where BASE is the commit recorded before the work began (`git merge-base HEAD main` if none was recorded; never `HEAD~1`). It prints a file path. Do not read the diff yourself: you wrote the change, and reading it before the reviewer reports pulls the review back toward your own view of it.
3. **Dispatch the review.** Give the reviewer the requirements and the diff path, never your reasoning, your summary of what you built, or this conversation.
   - **In Claude Code**, run both: they check different things, so skipping either leaves a gap. Use the built-in `/code-review` for bugs: run it on the same range (`/code-review <BASE>...HEAD`; with no range it covers commits ahead of upstream plus uncommitted work). Then dispatch one reviewer with `references/reviewer-prompt.md` with FOCUS set to "requirements and tests", because `/code-review` does not check the change against what was asked or whether the tests were weakened.
   - **Elsewhere**, or if `/code-review` is unavailable, dispatch one reviewer with `references/reviewer-prompt.md` and FOCUS set to "everything".
4. **Handle the results** from both, as one list of findings.
   - Output that does not follow the format is discarded and the review re-run fresh. Never repair a reviewer's output yourself.
   - Check each finding against the code before acting. Push back with evidence on findings that are wrong; do not implement a suggestion nothing calls for.
   - Re-grade by effect on a user, not by whether the spec mentioned it.
   - Fix Critical and Important findings, each with a test that fails first. List Minor ones for the user; do not loop on them.
5. **Re-review after fixes** with `references/re-review-prompt.md`: the verbatim findings plus a fix-only diff (`review-package <previous HEAD>`). Not a second full review.
6. **Stop rule.** At most three fix rounds. If findings remain, stop and give the user each open finding with your judgement: reviewer is wrong (why), real but not blocking, or blocking (smallest change that unblocks).
7. **Report** the reviewer's verdict lines, what you fixed, what you declined and why, and what was not reviewed.

## Rules
- One pass per kind of check. More reviewers produce more findings, not more truth.
- The reviewer is read-only and does not spawn subagents. It starts from the diff and reads further only to validate a named risk: callers of a changed contract, shared state, concurrency, or fit with the architecture.
- A finding needs a file:line, who or what is affected, and the concrete wrong result. "Could be cleaner" with no consequence is not a finding.
- "Nothing found" is a valid result. Do not ask the reviewer to try harder until it invents something.
- Security-focused review of a whole codebase is a different job: use `swe-security-audit`.
