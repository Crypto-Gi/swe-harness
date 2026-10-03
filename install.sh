#!/bin/sh
# ./install.sh            core skills only, copied from this repo (no network)
# ./install.sh browser    + swe-browser-check (from this repo)
# ./install.sh security   + swe-security-audit (fetched at the commit pinned in optional/sources)
# ./install.sh react      + swe-react          (fetched at the commit pinned in optional/sources)
# ./install.sh all        core and every optional skill
# Skills go to ~/.claude/skills and ~/.agents/skills.
set -e
cd "$(dirname "$0")"
dests="$HOME/.claude/skills $HOME/.agents/skills"

put() { # put SOURCE_DIR NAME
  for dest in $dests; do
    mkdir -p "$dest"
    rm -rf "${dest:?}/$2"
    cp -R "$1" "$dest/$2"
  done
  echo "installed $2"
}

fetch() { # fetch KEY: download one pinned specialist skill and install it
  line=$(grep "^$1|" optional/sources) || { echo "no entry for '$1' in optional/sources" >&2; exit 1; }
  name=$(echo "$line" | cut -d'|' -f2); repo=$(echo "$line" | cut -d'|' -f3)
  commit=$(echo "$line" | cut -d'|' -f4); path=$(echo "$line" | cut -d'|' -f5); licence=$(echo "$line" | cut -d'|' -f6)
  command -v git >/dev/null || { echo "git is needed to fetch $name" >&2; exit 1; }
  tmp=$(mktemp -d)
  echo "fetching $name from $repo at $commit"
  git init -q "$tmp/src"
  git -C "$tmp/src" fetch -q --depth 1 "$repo" "$commit" || { rm -rf "$tmp"; echo "fetch failed; nothing installed for $name" >&2; exit 1; }
  git -C "$tmp/src" checkout -q FETCH_HEAD
  got=$(git -C "$tmp/src" rev-parse HEAD)
  [ "$got" = "$commit" ] || { rm -rf "$tmp"; echo "got $got, expected $commit; nothing installed" >&2; exit 1; }
  [ -f "$tmp/src/$path/SKILL.md" ] || { rm -rf "$tmp"; echo "$path/SKILL.md not found upstream; nothing installed" >&2; exit 1; }
  mkdir "$tmp/out"; cp -R "$tmp/src/$path" "$tmp/out/$name"
  # the skill's name must match its folder to load
  sed "s/^name: .*/name: $name/" "$tmp/src/$path/SKILL.md" > "$tmp/out/$name/SKILL.md"
  for f in LICENSE LICENSE.txt LICENSE.md; do
    [ -f "$tmp/src/$f" ] && [ ! -f "$tmp/out/$name/$f" ] && cp "$tmp/src/$f" "$tmp/out/$name/$f"
  done
  if [ "$1" = react ]; then # 3,800-line compiled copy of the rules; the rule files are loaded one at a time instead
    rm -f "$tmp/out/$name/AGENTS.md"
    grep -v -e 'all rules expanded' -e '^## Full Compiled Document' "$tmp/out/$name/SKILL.md" > "$tmp/skill" && mv "$tmp/skill" "$tmp/out/$name/SKILL.md"
  fi
  printf 'Installed by swe-harness install.sh\nsource: %s\npath: %s\ncommit: %s\nlicence: %s\nchanged: name in SKILL.md frontmatter%s\n' \
    "$repo" "$path" "$commit" "$licence" "$([ "$1" = react ] && echo '; compiled AGENTS.md removed')" > "$tmp/out/$name/SOURCE"
  put "$tmp/out/$name" "$name"
  rm -rf "$tmp"
}

for d in skills/*/; do put "$d" "$(basename "$d")"; done
[ "$#" -gt 0 ] || set -- core
for arg in "$@"; do
  case "$arg" in
    core) ;;
    browser) put optional/swe-browser-check swe-browser-check ;;
    security|react) fetch "$arg" ;;
    all) put optional/swe-browser-check swe-browser-check; fetch security; fetch react ;;
    *) echo "usage: $0 [browser] [security] [react] [all]" >&2; exit 1 ;;
  esac
done
echo "done: restart the agent to load the skills"
