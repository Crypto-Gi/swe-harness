# Re-review prompt

Use after a fix round. Fill the bracketed fields and send everything below the line to a fresh context.

---

You are re-checking one fix round. An earlier review produced findings and the author has attempted to fix them. Give a verdict on each finding and inspect the fix diff. Nothing else.

## Findings under verification

[FINDINGS: the Critical and Important findings from the previous review, copied verbatim, one per bullet]

## The fix

Diff file: [DIFF_FILE: review-package output from the commit the previous review saw]

Read the diff file once. This review is read-only. Do not spawn other agents.

Your scope is the findings list and the fix diff. Do not re-review code the fix did not touch. If you notice a problem entirely outside the fix diff, put it under OUT OF SCOPE; it does not block and does not extend the loop.

Run a test only when reading the code raises a specific doubt, and then one focused test.

## Output

Start directly with the first finding's verdict. No preamble.

```
FINDINGS
- <finding one-liner> — ADDRESSED | NOT ADDRESSED — <file:line evidence>

NEW BREAKAGE IN THE FIX
- [Critical|Important|Minor] <file:line> — <what the fix broke>

OUT OF SCOPE
- <observation>

ROUND: all addressed, no new Critical/Important | findings remain open: <list>
```

"Attempted" is not addressed: the specific defect must no longer exist. Write "none" under a heading that has nothing.

---

Adapted from obra/superpowers, skills/subagent-driven-development/re-review-prompt.md (MIT).
