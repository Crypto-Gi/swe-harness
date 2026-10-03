---
name: swe-debug
description: Diagnosis loop for hard bugs, flaky tests and performance regressions. Use when the user says "debug this", "diagnose", "why is this failing", "it's flaky", "this got slow", or when a fix attempt has already failed once. Not for a typo or an error whose cause is on the screen.
---

# Debug

## 1. Build a command that goes red on this bug
Do this before forming a theory. If you catch yourself reading code to guess the cause and no such command exists yet, stop and build it.

Ways to get one, in rough order: a failing test at whatever level reaches the bug; a curl or CLI call with fixed input compared to known-good output; a headless browser script; a captured request or payload replayed through the code path; a minimal harness around one function; a loop over random inputs for "sometimes wrong"; `git bisect run` when it worked at an earlier commit; a diff of old against new output for the same input.

The command is ready when you have run it, shown its output, and it is:
- **red on this bug**: it asserts the user's exact symptom, not "did not crash"
- **deterministic**: same verdict each run (flaky bug: loop it until the failure rate is high enough to work against)
- **fast**: seconds
- **runnable by you** without a human

If you cannot build one, say so, list what you tried, and ask for one of: access to an environment that reproduces it, a captured artifact (log, HAR, core dump), or permission to add temporary instrumentation. Do not go on to guess.

Redact secrets in anything you show. Read credentials from the environment, not from the command line.

## 2. Shrink it
Remove inputs, callers, config and steps one at a time, re-running after each, until removing any remaining piece makes it pass. Confirm it is still the user's symptom and not a nearby failure.

## 3. Hypotheses
Write three to five, ranked, before testing any. Each states a prediction: "if X is the cause, changing Y makes it pass." No prediction, no hypothesis. Show the list to the user; go on with your ranking if they don't respond.

## 4. Find where it breaks
- Change one thing per run.
- For a failure that crosses components, log what enters and leaves each boundary, run once, and read where the value first goes wrong. Trace backward from there to the source; fix the source, not the place the symptom shows.
- Prefer one breakpoint or one targeted log to logging everything. Tag every debug line with one unique marker, such as `[DEBUG-a4f2]`, so cleanup is one grep.
- Performance: measure a baseline first, then bisect. Compare against run-to-run noise; a change that does not beat the noise is reverted, not kept.

## 5. Fix
1. Turn the shrunken repro into a test and watch it fail. If no test can reach the real bug pattern, say so: that gap is a finding.
2. Fix the cause in the shared function, not in each caller. Grep every caller first.
3. Watch the test pass, then run the original, un-shrunk command from step 1.

**After three failed fixes, stop.** Do not try a fourth. Three misses mean the model of the problem is wrong: tell the user what you tried, what each attempt ruled out, and what you now doubt about the design.

## 6. Before saying it is fixed
- the step 1 command is green, and the regression test passes
- every tagged debug line is gone (`grep` the marker)
- throwaway harnesses are deleted
- the commit message states the cause that turned out to be right
- then `swe-verify`

---
Adapted from mattpocock/skills, skills/engineering/diagnosing-bugs (MIT), with the boundary-logging and three-fix rules from obra/superpowers systematic-debugging (MIT).
