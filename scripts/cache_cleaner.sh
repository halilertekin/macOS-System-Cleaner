#!/bin/bash

# macOS Cache Cleaner Script
# This script analyzes and optionally cleans various cache directories on macOS
# Designed to be run as part of a brew update process or standalone

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to get directory size
get_dir_size() {
    du -sh "$1" 2>/dev/null | cut -f1
}

# Function to analyze caches
analyze_caches() {
    print_status "Analyzing cache sizes..."
    echo
    
    # User caches
    echo "=== USER CACHES ==="
    if [ -d "$HOME/Library/Caches" ]; then
        total_user_cache=$(get_dir_size "$HOME/Library/Caches")
        echo "Total User Cache Size: $total_user_cache"
        
        echo "Top 10 Largest User Caches:"
        du -sh "$HOME/Library/Caches"/* 2>/dev/null | grep -v "Operation not permitted" | sort -hr | head -10
        echo
    fi
    
    # npm cache
    echo "=== NPM/YARN CACHES ==="
    if command -v npm &> /dev/null; then
        npm_cache_info=$(npm cache verify 2>/dev/null | grep -E "(Content verified|Content garbage-collected)" || echo "npm not available")
        echo "npm cache: $npm_cache_info"
    else
        echo "npm not installed"
    fi
    
    if command -v yarn &> /dev/null; then
        yarn_cache_size=$(get_dir_size "$HOME/Library/Caches/Yarn")
        echo "Yarn cache size: $yarn_cache_size"
    else
        echo "Yarn not installed"
    fi
    
    # Homebrew cache
    echo -e "\n=== HOMEBREW CACHES ==="
    if command -v brew &> /dev/null; then
        print_status "Checking Homebrew cache..."
        brew cleanup --dry-run
    else
        echo "Homebrew not installed"
    fi
    
    # Temporary directories
    echo -e "\n=== TEMPORARY DIRECTORIES ==="
    tmp_size=$(get_dir_size "/tmp")
    echo "Size of /tmp: $tmp_size"
}

# Function to clean caches
clean_caches() {
    print_status "Starting cache cleaning process..."
    
    # Ask for confirmation before cleaning
    read -p "Do you want to proceed with cleaning caches? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Cache cleaning cancelled by user."
        return 0
    fi
    
    cleaned_size=0
    
    # Clean Google caches
    if [ -d "$HOME/Library/Caches/Google" ]; then
        size=$(get_dir_size "$HOME/Library/Caches/Google")
        print_status "Cleaning Google caches ($size)..."
        rm -rf "$HOME/Library/Caches/Google"/*
        print_success "Google caches cleaned"
    fi
    
    # Clean Adobe caches
    if [ -d "$HOME/Library/Caches/Adobe" ]; then
        size=$(get_dir_size "$HOME/Library/Caches/Adobe")
        print_status "Cleaning Adobe caches ($size)..."
        rm -rf "$HOME/Library/Caches/Adobe"/*
        print_success "Adobe caches cleaned"
    fi
    
    # Clean Playwright caches
    if [ -d "$HOME/Library/Caches/ms-playwright" ]; then
        size=$(get_dir_size "$HOME/Library/Caches/ms-playwright")
        print_status "Cleaning Playwright caches ($size)..."
        rm -rf "$HOME/Library/Caches/ms-playwright"/*
        print_success "Playwright caches cleaned"
    fi
    
    if [ -d "$HOME/Library/Caches/ms-playwright-go" ]; then
        size=$(get_dir_size "$HOME/Library/Caches/ms-playwright-go")
        print_status "Cleaning Playwright Go caches ($size)..."
        rm -rf "$HOME/Library/Caches/ms-playwright-go"/*
        print_success "Playwright Go caches cleaned"
    fi
    
    # Clean DeepL Translator cache
    if [ -d "$HOME/Library/Caches/com.linguee.DeepLCopyTranslator" ]; then
        size=$(get_dir_size "$HOME/Library/Caches/com.linguee.DeepLCopyTranslator")
        print_status "Cleaning DeepL Translator cache ($size)..."
        rm -rf "$HOME/Library/Caches/com.linguee.DeepLCopyTranslator"/*
        print_success "DeepL Translator cache cleaned"
    fi
    
    # Clean Spotify cache
    if [ -d "$HOME/Library/Caches/com.spotify.client" ]; then
        size=$(get_dir_size "$HOME/Library/Caches/com.spotify.client")
        print_status "Cleaning Spotify cache ($size)..."
        rm -rf "$HOME/Library/Caches/com.spotify.client"/*
        print_success "Spotify cache cleaned"
    fi
    
    # Clean Yarn cache
    if command -v yarn &> /dev/null; then
        print_status "Cleaning Yarn cache..."
        yarn cache clean
        print_success "Yarn cache cleaned"
    fi
    
    # Clean npm cache
    if command -v npm &> /dev/null; then
        print_status "Cleaning npm cache..."
        npm cache clean --force
        print_success "npm cache cleaned"
    fi
    
    # Clean Homebrew cache
    if command -v brew &> /dev/null; then
        print_status "Cleaning Homebrew cache..."
        brew cleanup
        print_success "Homebrew cache cleaned"
    fi
    
    print_success "Cache cleaning completed!"
}

# Function to run analysis only
analyze_only() {
    print_status "Running cache analysis only (no cleaning)..."
    analyze_caches
}

# Main function
main() {
    case "${1:-help}" in
        "clean")
            analyze_caches
            clean_caches
            ;;
        "analyze")
            analyze_only
            ;;
        "help"|*)
            echo "Usage: $0 [command]"
            echo
            echo "Commands:"
            echo "  clean    - Analyze and optionally clean caches"
            echo "  analyze  - Analyze caches only (no cleaning)"
            echo "  help     - Show this help message"
            echo
            echo "Run as part of brew update to automatically analyze and clean caches."
            ;;
    esac
}

# Run main function with all arguments
main "$@"