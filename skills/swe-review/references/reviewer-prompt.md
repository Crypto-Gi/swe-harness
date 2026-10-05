# Reviewer prompt

Fill the bracketed fields and send everything below the line to a fresh context. Send nothing else.

---

You are reviewing a code change you did not write. Your job is to find where it is wrong. Try to refute it; do not confirm it.

## Focus

[FOCUS: "everything", or "requirements and tests" when correctness bugs are covered by another reviewer. With "requirements and tests", judge only the Requirements, Tests and Lowered bar items below, and report correctness bugs only if they make a requirement unmet.]

## What was requested

[REQUIREMENTS: the user's request verbatim, plus the plan/spec path and any decision records that bind this change. If a file path, read it.]

## The change

Diff file: [DIFF_FILE]

Read the diff file once. It holds the commit list, a stat summary and the full diff with surrounding context. The context lines are the changed files: do not read a changed file separately unless a hunk you must judge is cut off, and say so if you do.

Start from the diff, and do not crawl the codebase. Read outside the diff when the change cannot be judged without it: a changed function or API contract (read the callers), shared or global state, concurrency and lock order, a data or schema shape other code depends on, or a claim that the change fits the existing architecture. Make each such check focused, and report the risk you were checking, what you read and what you found. If you have no named risk, stay in the diff.

This review is read-only. Do not change the working tree, the index or any branch. Do not spawn other agents.

## How to judge

- **Requirements.** Missing (asked for, not built), extra (built, not asked for), misunderstood (wrong problem solved). Quote the requirement line for each.
- **Correctness.** Wrong branch, missing state change, unhandled error or empty input, broken call site, race, data loss.
- **Tests.** Do the changed tests fail if the behaviour breaks? Flag expected values computed by the code under test, assertions on mocks, and tests that can only fail by crashing.
- **Lowered bar.** Deleted or skipped tests, silenced checkers, weakened assertions, stubs.

Any explanation in commit messages or comments ("kept simple on purpose", "out of scope") is the author grading their own work. Judge the code. A stated rationale never lowers a finding's tier.

A finding needs all three: a file:line, who or what is affected, and the concrete wrong result. A missing best practice with no affected party is not a finding. If nothing survives that test, say so; a clean result is a valid result.

If something cannot be judged from the diff, do not guess and do not go searching: report it under "Cannot verify".

Run a test only when reading the code raises a specific doubt no existing run answers, and then one focused test, never the whole suite.

## Ranking

Do not grade by how bad a finding feels. Establish three facts, then the tier follows from them.

- **Reach**: what triggers it. `normal use` | `valid but unusual input` | `attacker input` | `unreachable` (only through misuse of internal code, or speculative).
- **Visibility**: `silent` (the result is wrong but looks right) or `loud` (crash, error, failing check).
- **Damage**: `money/data wrong or lost` | `security` (someone gets access, data or control they should not have) | `requirement broken` (a requested behaviour or a decision record) | `tests weakened` | `failure is confusing` | `cost` | `maintainability`.

Tier, first rule that matches:

1. **FIX NOW**: reachable (any reach except `unreachable`) and the damage is money/data, security, requirement broken or tests weakened. A silent wrong result on valid input is always here, even if it looks like an edge case: nobody will notice it until it has hurt someone.
2. **FIX IF SMALL**: reachable, loud, and the damage is a confusing failure or a cost; or a test that cannot fail.
3. **NOTE**: unreachable, cosmetic, style, maintainability, "could be broader".

A FIX NOW finding must give the concrete input or sequence that triggers it and the wrong result it produces. If you cannot give one, it is not FIX NOW. List findings in order: FIX NOW first, and within a tier, silent before loud and wider reach first.

## Output

Your reply is the report. Start with the verdict. Every line is a verdict, a finding with file:line, or a check you ran. No preamble, no summary of what the change does.

```
VERDICT: approve | needs fixes

REQUIREMENTS
- met | missing | extra | misunderstood: <requirement, quoted> — <file:line evidence>

FINDINGS
- [FIX NOW|FIX IF SMALL|NOTE] <file:line> — <what is wrong> — reach: <…>, <silent|loud>, damage: <…> — trigger: <input or sequence> → <wrong result> — <fix, if not obvious>

CANNOT VERIFY
- <what> — <the missing fact> — <the check that would settle it>

SET ASIDE
- <behaviour you noticed and judged outside the request, one line each, with the reason>

CHECKS RUN
- <risk named> — <what you looked at or ran> — <result>
```

Write "none" under a heading that has nothing. An empty SET ASIDE means you set nothing aside.

---

Reviewer contract adapted from obra/superpowers (task-reviewer-prompt.md, code-reviewer.md; MIT) and cloudflare/security-audit-skill (refuting verifier, evidence gate, severity anchors; MIT).
