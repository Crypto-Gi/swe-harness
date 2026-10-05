---
name: swe-verify
description: Prove that code work is finished before saying so. Use before claiming a task, fix or feature is done, complete, working or passing, before committing or opening a PR, and when the user asks "is it done", "did the tests pass", "verify this" or "run the checks". Also use when writing or changing tests.
---

# Verify

Done is an exit code, not a statement. Scripts are in this skill's `scripts/` folder; run them with `bash`.

## Before saying work is done
1. Take the project's check command from `AGENTS.md`. If there is none, find it (CI config, manifest scripts), run it, and offer to record it.
2. Run it through the recorder, after your last edit:
   `bash scripts/verified <label> -- <check command>`
   It prints the last lines and records the pass in `.swe/verified.log` only on exit 0. A non-zero exit means the work is not done: fix the cause and run it again.
3. Run `bash scripts/test-guard`. It flags deleted tests, skipped or focused tests, silenced checkers and removed assertions. Fix each finding in the code. Mark a line `guard-ok: <reason>` only when the removal is the requested change, and say so in your report.
4. Report in this shape:
   - the `verified:` line the recorder printed (command, commit, last output line)
   - what you did not or could not check, each with the missing fact and how to check it
   - every `Ruling:` you made

## Rules
- A claim needs evidence produced after the last edit. "Should pass" and a subagent's "success" are not evidence; the command output and the diff are.
- A bug fix needs a test that fails without the fix. Confirm it: run it red before the fix, or revert the fix, see it fail, restore. Exception: when reproducing the bug in a test is genuinely impractical (hardware, timing, a third-party outage, production-only data), say so, state what you checked instead, and put both in the commit message. "No time" is not this exception.
- Your task's scope limits what you change, not what you check. Run the whole check and report failures you did not cause as pre-existing; do not fix them unasked.
- A check that cannot run is "not verified", never "passed". Say which check and why.
- A new check or guardrail is not done until it has passed, failed on a planted violation, and passed again.
- UI changes: also use `swe-browser-check`.
- A runnable app whose change tests cannot show (a CLI, a server, a page): in Claude Code, tell the user `/verify` will build, run and observe it; it runs only when they invoke it.

## Writing or changing tests
Read `references/writing-good-tests.md` first. The short form: name the production change that would make the test fail; expected values are literals, never computed by the code under test; assert on real behaviour, not on a mock.
