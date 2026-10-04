# Eval

Real agent sessions against a small test project, with automatic checks. Run it before and after changing a skill, so a change is judged by what agents do, not by how the text reads.

```bash
eval/run                       # Sonnet 5.5, the default most people get
eval/run claude-opus-5-5       # any other model
```

Each task starts from a fresh copy of the `invoicer` project (`fixture.sh`: stdlib Python, one planted bug) with the core skills installed in the project only. User settings and plugins are not loaded. A full run takes a few minutes and costs about $1-2 of usage on Sonnet.

| Task | What it checks |
|---|---|
| bootstrap | skill fires; `AGENTS.md` short, no counts or known bugs; `CLAUDE.md` is `@AGENTS.md`; no code touched |
| bug, not bootstrapped | `swe-change` fires on a plain bug report; fix works; test added; `verified` and `test-guard` used; nothing committed |
| feature with commit | one commit; README updated in it; message explains why; `verified` used |
| vague "make it faster" | no code changed without a measurement |
| review | `swe-review` fires; finds the planted silent misparse; changes nothing |

Agents are not deterministic: one failed check is a signal to read the transcript in `eval/results/`, not proof. Run twice before concluding a change made things worse. Claude Code only for now; a Codex runner is still to do.
