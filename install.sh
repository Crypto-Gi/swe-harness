#!/bin/sh
# ./install.sh            core skills only, copied from this repo (no network)
# ./install.sh browser    + swe-browser-check (from this repo)
# ./install.sh security   + swe-security-audit (fetched at the commit pinned in optional/sources)
# ./install.sh react      + swe-react          (fetched at the commit pinned in optional/sources)
# ./install.sh all        core and every optional skill
# ./install.sh zip        rebuild zips/ (core + browser) for uploading to the Claude apps; installs nothing
# ./install.sh version    show the installed version
# ./install.sh uninstall  remove every skill this repo installs
# Skills go to ~/.claude/skills and ~/.agents/skills. pointer.md is merged, as a marked block, into
# ~/.claude/CLAUDE.md and (if ~/.codex exists) ~/.codex/AGENTS.md: in trials, skills alone fired on
# 7 of 11 prompts and 11 of 11 with the pointer. Uninstall removes the block and nothing else.
set -e
cd "$(dirname "$0")"
dests="$HOME/.claude/skills $HOME/.agents/skills"
version=$(cat VERSION)
names="swe-bootstrap swe-change swe-verify swe-review swe-debug swe-browser-check swe-security-audit swe-react"
start='<!-- swe-harness:start (added by swe-harness install.sh; ./install.sh uninstall removes it) -->'
end='<!-- swe-harness:end -->'

pointer_files() {
  echo "$HOME/.claude/CLAUDE.md"
  if [ -d "$HOME/.codex" ]; then echo "$HOME/.codex/AGENTS.md"; fi
}
strip_block() { # strip_block FILE : print FILE without the swe-harness block
  awk '/^<!-- swe-harness:start/ {skip=1} !skip {print} /^<!-- swe-harness:end/ {skip=0}' "$1"
}
pointer() { # pointer add|remove
  for f in $(pointer_files); do
    rest=""; [ -f "$f" ] && rest=$(strip_block "$f")
    if [ "$1" = add ]; then
      mkdir -p "$(dirname "$f")"
      { if [ -n "$rest" ]; then printf '%s\n\n' "$rest"; fi; echo "$start"; cat pointer.md; echo "$end"; } > "$f.swe-tmp" && mv "$f.swe-tmp" "$f"
      echo "pointer block in $f"
    elif [ -f "$f" ] && grep -q '^<!-- swe-harness:start' "$f"; then
      if [ -n "$(printf '%s' "$rest" | tr -d '[:space:]')" ]; then printf '%s\n' "$rest" > "$f"; else rm "$f"; fi
      echo "removed pointer block from $f"
    fi
  done
}

case "${1:-}" in
  version)
    for dest in $dests; do
      f="$dest/swe-change/.swe-harness-version"
      if [ -f "$f" ]; then echo "$dest: $(cat "$f")"; else echo "$dest: not installed"; fi
    done
    echo "this checkout: $version"
    exit 0 ;;
  uninstall)
    for dest in $dests; do
      for n in $names; do
        [ -d "$dest/$n" ] && rm -r "${dest:?}/${n:?}" && echo "removed $dest/$n"
      done
    done
    pointer remove
    echo "done: restart the agent"
    exit 0 ;;
esac

put() { # put SOURCE_DIR NAME
  for dest in $dests; do
    mkdir -p "$dest"
    rm -rf "${dest:?}/$2"
    cp -R "$1" "$dest/$2"
    echo "$version" > "$dest/$2/.swe-harness-version"
  done
  echo "installed $2 ($version)"
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

if [ "${1:-}" = zip ]; then
  command -v python3 >/dev/null || { echo "python3 is needed to build zips" >&2; exit 1; }
  mkdir -p zips
  for d in skills/*/ optional/swe-browser-check/; do
    python3 - "$d" <<'PY2'
import os, sys, zipfile
src = sys.argv[1].rstrip('/'); name = os.path.basename(src)
with zipfile.ZipFile(f'zips/{name}.zip', 'w', zipfile.ZIP_DEFLATED) as z:
    for root, dirs, files in os.walk(src):
        dirs.sort()
        for f in sorted(files):
            p = os.path.join(root, f)
            info = zipfile.ZipInfo(os.path.join(name, os.path.relpath(p, src)), (1980, 1, 1, 0, 0, 0))
            info.external_attr = (0o755 if os.access(p, os.X_OK) else 0o644) << 16
            z.writestr(info, open(p, 'rb').read(), zipfile.ZIP_DEFLATED)
PY2
    echo "zips/$(basename "$d").zip"
  done
  exit 0
fi

for d in skills/*/; do put "$d" "$(basename "$d")"; done
[ "$#" -gt 0 ] || set -- core
for arg in "$@"; do
  case "$arg" in
    core) ;;
    browser) put optional/swe-browser-check swe-browser-check ;;
    security|react) fetch "$arg" ;;
    all) put optional/swe-browser-check swe-browser-check; fetch security; fetch react ;;
    *) echo "usage: $0 [browser] [security] [react] [all] | $0 zip" >&2; exit 1 ;;
  esac
done
pointer add
echo "done: restart the agent to load the skills"
