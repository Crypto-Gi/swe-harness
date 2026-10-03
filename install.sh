#!/bin/sh
# ./install.sh        -> all skills to ~/.claude/skills and ~/.agents/skills
# ./install.sh core   -> the four core skills only
set -e
cd "$(dirname "$0")"
case "${1:-all}" in
  all)  set -- skills/*/ ;;
  core) set -- skills/swe-bootstrap/ skills/swe-verify/ skills/swe-review/ skills/swe-debug/ ;;
  *) echo "usage: $0 [core]"; exit 1 ;;
esac
for dest in "$HOME/.claude/skills" "$HOME/.agents/skills"; do
  mkdir -p "$dest"
  for d in "$@"; do
    n=$(basename "$d")
    rm -rf "${dest:?}/$n"
    cp -R "$d" "$dest/$n"
  done
  echo "installed $# skill(s) to $dest"
done
echo "restart the agent to load them"
