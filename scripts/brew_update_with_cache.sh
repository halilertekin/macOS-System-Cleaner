#!/bin/bash
# Wrapper script that runs brew update followed by cache analysis

echo "Running brew update..."
brew update

echo ""
echo "Running cache analysis after brew update..."
/Users/halil/cache_cleaner.sh analyze

echo ""
echo "To clean caches after review, run: /Users/halil/cache_cleaner.sh clean"
