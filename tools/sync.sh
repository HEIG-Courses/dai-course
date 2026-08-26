#!/usr/bin/env bash
#
# sync.sh — two-way sync between the semester fork and the upstream course.
#
#   pull:  update the fork from upstream (after upstream improvements)
#   push:  open a PR contributing the fork's accumulated fixes upstream
#
# Usage: ./sync.sh pull|push <org> [upstream]
#   e.g. ./sync.sh pull heig-vd-dai-2027
#        ./sync.sh push heig-vd-dai-2027

set -euo pipefail

UPSTREAM="${3:-HEIG-Courses/dai-course}"
REPO_NAME="${UPSTREAM#*/}"

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 pull|push <org> [upstream (default: $UPSTREAM)]" >&2
  exit 1
fi
MODE="$1"
ORG="$2"
FORK="$ORG/$REPO_NAME"

case "$MODE" in
  pull)
    echo "==> Syncing $FORK from $UPSTREAM"
    gh repo sync "$FORK" --source "$UPSTREAM"
    ;;
  push)
    echo "==> Opening PR: $FORK -> $UPSTREAM"
    gh pr create -R "$UPSTREAM" \
      --head "$ORG:main" \
      --title "Semester fixes from $ORG" \
      --body "Accumulated fixes and improvements made during the semester in $FORK." \
      --web
    ;;
  *)
    echo "Unknown mode '$MODE' (use pull or push)" >&2
    exit 1
    ;;
esac
