# Formats

Both are deliberately small. Add nothing a reader would not use.

## Spec: `docs/specs/<area>.md`

One file per area of behaviour, created the first time it is needed.

```md
# <Area>

## <Requirement name>
The system must <behaviour, in one sentence>.

- Given <state>, when <action>, then <observable result>.
- Given <state>, when <action>, then <observable result>.

Tests: <test name or path, if one proves it>
```

- Describe behaviour a user or caller can observe. No file paths, class names or code: those go stale and the code already has them.
- A requirement can be one sentence and one scenario.
- Behaviour changes and the spec changes land in the same commit.
- If the spec and the tests disagree, do not pick one silently: raise it.
- When a spec describes something the code no longer does and nobody wants, delete that requirement.

## Plan: `docs/plans/<slug>.md`

Temporary. It exists so a fresh session can continue the work without this conversation.

```md
# <What is being built>

Goal: <one or two sentences, and what done looks like>
Base commit: <sha before the work started>

## Approach
<the chosen approach, and alternatives rejected with why>

## Steps
- [ ] <step>
- [x] <finished step> (verified: <command>)

## Decided so far
- <decision the user made or confirmed>

## Open
- <question or risk>
```

- Tick a step only after its check passed.
- Keep it current as you learn; a plan that no longer matches the work is worse than none.
- At close-out, move what is durable to its home (see the skill) and delete the file.
