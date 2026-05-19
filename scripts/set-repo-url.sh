#!/usr/bin/env sh
set -eu

OLD_URL="https://github.com/catdevdev/gitops-template-argocd.git"
NEW_URL="${1:-}"

if [ -z "$NEW_URL" ]; then
  NEW_URL="$(git remote get-url origin 2>/dev/null || true)"
fi

if [ -z "$NEW_URL" ]; then
  echo "Usage: scripts/set-repo-url.sh https://github.com/<owner>/<repo>.git" >&2
  exit 1
fi

if command -v rg >/dev/null 2>&1; then
  FILES="$(rg -l "$OLD_URL" . || true)"
else
  FILES="$(grep -Rsl "$OLD_URL" . || true)"
fi

if [ -z "$FILES" ]; then
  echo "No template repository URLs found."
  exit 0
fi

printf '%s\n' "$FILES" | while IFS= read -r file; do
  perl -pi -e "s|\\Q$OLD_URL\\E|$NEW_URL|g" "$file"
done

echo "Updated repository URL to $NEW_URL"
