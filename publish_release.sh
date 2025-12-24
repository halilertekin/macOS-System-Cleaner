#!/bin/bash
set -e

# Configuration
SOURCE_FORMULA="/Users/halil/macOS-System-Cleaner/macos-system-cleaner.rb"
TAP_DIR="/Users/halil/homebrew-tap"
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
git commit -m "feat: update macos-system-cleaner to v1.1.0" || echo -e "${BLUE}[INFO]${NC} Nothing to commit or commit failed."

echo -e "${BLUE}[INFO]${NC} Pushing to remote..."
git push origin HEAD

echo -e "${GREEN}[SUCCESS]${NC} Successfully published macos-system-cleaner v1.1.0 to your Tap!"
echo -e "${BLUE}[INFO]${NC} You can now install it using:"
echo "  brew tap halilertekin/tap"
echo "  brew install macos-system-cleaner"
