# Eval

Real agent sessions against a small test project, with automatic checks. Run it before and after changing a skill, so a change is judged by what agents do, not by how the text reads.

```bash
eval/run                       # Sonnet 5.5, the default most people get
eval/run claude-opus-5-5       # any other model
EVAL_ARM=without eval/run      # the same tasks with no skills and no pointer, as a baseline
```

Each task starts from a fresh copy of the `invoicer` project (`fixture.sh`: stdlib Python, one planted bug). Each session gets its own config folder holding only what `./install.sh` puts in `~/.claude`: the core skills and the `pointer.md` block. Your own settings and plugins are not loaded. A full run takes about ten minutes and costs about $2-3 of usage on Sonnet.

| Task | What it checks |
|---|---|
| bootstrap | skill fires; `AGENTS.md` short, no counts or known bugs; `CLAUDE.md` is `@AGENTS.md`; no code touched |
| bug, not bootstrapped | `swe-change` fires on a plain bug report; fix works; test added; `verified` and `test-guard` used; nothing committed |
| feature with commit | one commit; README updated in it; message explains why; `verified` used |
| vague "make it faster" | no code changed without a measurement |
| review | `swe-review` fires; finds the planted silent misparse and ranks it FIX NOW; changes nothing |
| one-line rename | `swe-change` fires even on a trivial edit (it did not without the pointer) |
| rule from outside the code | session 1 records the accountant's reason where the next editor looks; session 2, asked to "simplify", keeps the rule and asks first (plain Sonnet undid it 3 of 3 times) |

Agents are not deterministic: one failed check is a signal to read the transcript in `eval/results/`, not proof. Run twice before concluding a change made things worse. Claude Code only for now; a Codex runner is still to do.
