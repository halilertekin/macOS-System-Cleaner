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

# ---------- Configuration ----------
NPM_DIR="$PROJECT_ROOT"
HOMEBREW_SCRIPT="$PROJECT_ROOT/publish_release.sh"
GIT_REMOTE="origin"
GIT_BRANCH="main"

# ---------- npm authentication ----------
# Fallback to NODE_AUTH_TOKEN if NPM_TOKEN is not set
NPM_TOKEN="${NPM_TOKEN:-$NODE_AUTH_TOKEN}"

if [[ -z "$NPM_TOKEN" ]]; then
  echo -e "\e[33m[WARN] NPM_TOKEN/NODE_AUTH_TOKEN is empty or not set.\e[0m"
else
  echo -e "\e[34m[INFO] Configuring npm authentication (Token length: ${#NPM_TOKEN})...\e[0m"
  # Create .npmrc in the project directory
  echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" > "$PROJECT_ROOT/.npmrc"
  # Also set it in HOME if it exists, otherwise skip
  if [[ -n "$HOME" ]]; then
    echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" > "$HOME/.npmrc"
  fi
fi

# ---------- Git commit (if any) ----------
if [[ "$GITHUB_ACTIONS" != "true" ]]; then
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
fi

# ---------- npm publish ----------
echo -e "\e[34m[INFO]\e[0m Publishing to npm (public)..."
npm publish --access public

# ---------- Git tag & push ----------
if [[ "$GITHUB_ACTIONS" != "true" ]]; then
  NEW_TAG=$(git describe --tags --abbrev=0)
  echo -e "\e[34m[INFO]\e[0m Pushing commit and tag ${NEW_TAG} to ${GIT_REMOTE}/${GIT_BRANCH}..."
  git push "$GIT_REMOTE" "$GIT_BRANCH"
  git push "$GIT_REMOTE" "$NEW_TAG"
fi

# ---------- Homebrew publish ----------
if [[ -x "$HOMEBREW_SCRIPT" ]]; then
  echo -e "\e[34m[INFO]\e[0m Running Homebrew publish script..."
  "$HOMEBREW_SCRIPT"
else
  echo -e "\e[31m[ERROR]\e[0m publish_release.sh not found or not executable."
  exit 1
fi

echo -e "\e[32m[SUCCESS]\e[0m Release process completed!"
