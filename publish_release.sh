#!/bin/bash
set -e

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_FORMULA="$PROJECT_ROOT/macos-system-cleaner.rb"
TAP_REPO="halilertekin/homebrew-tap"
TAP_DIR="/Users/halil/homebrew-tap"

# Check if running in GitHub Actions
if [[ "$GITHUB_ACTIONS" == "true" ]]; then
    # In CI, we use a temporary directory for the Tap
    TAP_DIR="$PROJECT_ROOT/temp-homebrew-tap"
    echo -e "${BLUE}[INFO]${NC} Running in CI mode. Cloning $TAP_REPO..."
    
    # Clean up any existing temp dir
    rm -rf "$TAP_DIR"
    
    # Use PAT if provided, or try default token
    # We use the GH_PAT secret from the environment
    GIT_AUTH_URL="https://x-access-token:${GH_PAT:-$GITHUB_TOKEN}@github.com/${TAP_REPO}.git"
    
    git clone "$GIT_AUTH_URL" "$TAP_DIR"
    
    # Configure git for committing in CI
    cd "$TAP_DIR"
    git config user.name "github-actions[bot]"
    git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
fi

TARGET_FORMULA="$TAP_DIR/Formula/macos-system-cleaner.rb"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}[INFO]${NC} Starting publication process..."

# Check if Tap directory exists
if [ ! -d "$TAP_DIR" ]; then
    echo -e "${RED}[ERROR]${NC} Tap directory not found at $TAP_DIR"
    exit 1
fi

# Copy formula
echo -e "${BLUE}[INFO]${NC} Copying formula to Tap..."
cp "$SOURCE_FORMULA" "$TARGET_FORMULA"
echo -e "${GREEN}[SUCCESS]${NC} Formula copied."

# Git operations
cd "$TAP_DIR"
echo -e "${BLUE}[INFO]${NC} Committing changes in $TAP_DIR..."

# Check if there are changes
if git diff --quiet && git diff --staged --quiet && [ -f "$TARGET_FORMULA" ]; then
   # Check if file is untracked
   if [ -z "$(git status --porcelain)" ]; then
       echo -e "${BLUE}[INFO]${NC} No changes to commit."
       exit 0
   fi
fi

git add Formula/macos-system-cleaner.rb
# Get current tag from source repo
CURRENT_TAG=$(cd "$PROJECT_ROOT" && git describe --tags --abbrev=0)

git commit -m "feat: update macos-system-cleaner to $CURRENT_TAG" || echo -e "${BLUE}[INFO]${NC} Nothing to commit or commit failed."

echo -e "${BLUE}[INFO]${NC} Pushing to remote..."
if [[ "$GITHUB_ACTIONS" == "true" ]]; then
    git push origin main
else
    git push origin HEAD
fi

echo -e "${GREEN}[SUCCESS]${NC} Successfully published macos-system-cleaner $CURRENT_TAG to your Tap!"
echo -e "${BLUE}[INFO]${NC} You can now install it using:"
echo "  brew tap halilertekin/tap"
echo "  brew install macos-system-cleaner"
