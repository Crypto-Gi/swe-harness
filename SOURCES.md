# Sources

What was taken from where. Commits are the upstream revisions read on 2026-10-03.

## Fetched on request, not stored here

Pinned in `optional/sources` and downloaded by `./install.sh <key>`. The installed folder gets a `SOURCE` file with the same facts.

| Key | Installed as | From | Commit | Licence | Changed at install |
|---|---|---|---|---|---|
| `security` | `swe-security-audit` | cloudflare/security-audit-skill, `skills/security-audit/` | c1c8a8c | MIT, (c) 2025-2026 Cloudflare, Inc. | `name` in frontmatter; upstream `LICENSE` copied into the folder |
| `react` | `swe-react` | vercel-labs/agent-skills, `skills/react-best-practices/` | 063bee9 | MIT per upstream README and frontmatter; upstream has no LICENSE file | `name` in frontmatter; compiled `AGENTS.md` and the line pointing to it removed |

## Copied

| Here | From | Commit | Licence | Changes |
|---|---|---|---|---|
| `skills/swe-verify/references/writing-good-tests.md` | obra/superpowers, `skills/test-driven-development/writing-good-tests.md` | 8ca22db | MIT, (c) 2025 Jesse Vincent | Removed cross-references and two asides |

## Adapted

| Here | From | Commit | Licence | What was taken |
|---|---|---|---|---|
| `swe-verify/scripts/verified` | obra/superpowers, `executing-plans/scripts/task-done` | 8ca22db | MIT | Record completion only on exit 0; log to file, print the tail |
| `swe-review/scripts/review-package` | obra/superpowers, `subagent-driven-development/scripts/review-package` | 8ca22db | MIT | Diff to a file from a recorded base; range guards |
| `swe-review/references/reviewer-prompt.md` | obra/superpowers, `task-reviewer-prompt.md` and `code-reviewer.md` | 8ca22db | MIT | Distrust the author's rationale; named-risk checks; "cannot verify"; "set aside" list |
| same | cloudflare/security-audit-skill, `VALIDATION-AND-REPORTING.md`, `HUNTING.md`, `SKILL.md` | c1c8a8c | MIT | Refuting reviewer; evidence gate; severity capped by stated damage; discard malformed output |
| `swe-review/references/re-review-prompt.md` | obra/superpowers, `re-review-prompt.md` | 8ca22db | MIT | Per-finding verdicts on a fix-only diff |
| `swe-review/SKILL.md` | obra/superpowers; mattpocock/skills `code-review`; addyosmani/agent-skills `doubt-driven-development` | 8ca22db, d81f3a1, 1401c8b | MIT | Bounded fix rounds; reviewer gets requirements and diff, not the author's claims |
| `swe-debug/SKILL.md` | mattpocock/skills, `skills/engineering/diagnosing-bugs/SKILL.md` | d81f3a1 | MIT, (c) 2026 Matt Pocock | Reproduce-first loop, shrink, ranked hypotheses, tagged debug lines |
| same | obra/superpowers, `systematic-debugging` | 8ca22db | MIT | Boundary logging; stop after three failed fixes |
| `swe-bootstrap/assets/decisions-README.md` | mattpocock/skills, `domain-modeling/ADR-FORMAT.md` | d81f3a1 | MIT | One-paragraph format; three-condition trigger |
| `swe-verify/scripts/test-guard` | addyosmani/agent-skills, `constraint-driven-development/references/floor-guard.md` | 1401c8b | MIT, (c) 2025 Addy Osmani | The set of bar-lowering moves and the 0/1/2 exit contract; rewritten in bash and awk |
| `optional/swe-browser-check/SKILL.md` | addyosmani/agent-skills, `browser-testing-with-devtools` | 1401c8b | MIT | The list of runtime checks; untrusted page content |
| same | pbakaus/impeccable, `skill/SKILL.src.md` | e103efe | Apache-2.0 | Two-round limit; validate screenshots |
| `swe-bootstrap/assets/AGENTS.template.md` | DietrichGebert/ponytail, `AGENTS.md` | c982cd4 | MIT | The "stop at the first that holds" ladder, the grep-callers rule, shortcut comments |
| same | obra/superpowers, `subagent-driven-development/SKILL.md` | 8ca22db | MIT | Stop conditions; `Ruling:` format |
| `swe-change/SKILL.md` | obra/superpowers `executing-plans`, `subagent-driven-development`; OpenAI Cookbook ExecPlans; Fission-AI/OpenSpec concepts | 8ca22db | MIT; ideas only from the latter two | Living plan with decisions and open questions; requirement-plus-scenario spec shape. The close-out step is ours |
| `AGENTS.md` (this repo) | mattpocock/skills `writing-for-agents`; obra/superpowers `writing-skills` | d81f3a1, 8ca22db | MIT | Pruning test for instruction lines; descriptions state triggers, not workflow |

## Read and not used

Graphify-Labs/graphify (stored code graph), cathrynlavery/diagram-design (presentation diagrams), trailofbits/skills (CC BY-SA share-alike), and the routing, hook and orchestration parts of superpowers, agent-skills and ponytail.
