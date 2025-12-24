#!/usr/bin/env bash
# -------------------------------------------------
# Automated release script for macOS-System-Cleaner
#  - Git commit & push
#  - npm version bump (patch)
#  - npm publish (public)
#  - Homebrew formula publish (via publish_release.sh)
# -------------------------------------------------

set -e

# Set project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load environment variables from .env if present
if [[ -f "$PROJECT_ROOT/.env" ]]; then
  source "$PROJECT_ROOT/.env"
fi

# ---------- npm authentication ----------
if [[ -z "$NPM_TOKEN" ]]; then
  echo -e "\e[33m[WARN] NPM_TOKEN not set. Please run 'npm login' manually.\e[0m"
else
  echo -e "\e[34m[INFO] Setting npm auth token from NPM_TOKEN env variable.\e[0m"
  npm config set //registry.npmjs.org/:_authToken=$NPM_TOKEN
fi

# ---------- Configuration ----------
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NPM_DIR="$PROJECT_ROOT"
HOMEBREW_SCRIPT="$PROJECT_ROOT/publish_release.sh"
GIT_REMOTE="origin"
GIT_BRANCH="main"

# ---------- Git commit (if any) ----------
cd "$PROJECT_ROOT"
if [[ -n "$(git status --porcelain)" ]]; then
  echo -e "\e[34m[INFO]\e[0m Staging all changes..."
  git add -A
  echo -e "\e[34m[INFO]\e[0m Creating commit..."
  git commit -m "chore: prepare release"
else
  echo -e "\e[34m[INFO]\e[0m No local changes to commit."
fi

# ---------- npm version bump ----------
cd "$NPM_DIR"
echo -e "\e[34m[INFO]\e[0m Bumping npm version (patch)..."
npm version patch -m "chore: release v%s"

# ---------- npm publish ----------
echo -e "\e[34m[INFO]\e[0m Publishing to npm (public)..."
npm publish --access public

# ---------- Git tag & push ----------
NEW_TAG=$(git describe --tags --abbrev=0)
echo -e "\e[34m[INFO]\e[0m Pushing commit and tag ${NEW_TAG} to ${GIT_REMOTE}/${GIT_BRANCH}..."
git push "$GIT_REMOTE" "$GIT_BRANCH"
git push "$GIT_REMOTE" "$NEW_TAG"

# ---------- Homebrew publish ----------
if [[ -x "$HOMEBREW_SCRIPT" ]]; then
  echo -e "\e[34m[INFO]\e[0m Running Homebrew publish script..."
  "$HOMEBREW_SCRIPT"
else
  echo -e "\e[31m[ERROR]\e[0m publish_release.sh not found or not executable."
  exit 1
fi

echo -e "\e[32m[SUCCESS]\e[0m Release process completed!"
