#!/bin/sh
# Shell completion generation script
#
# This script generates shell completion files for bash, zsh, and fish.
# It should be called from .goreleaser.yml during the release process.
#
# Usage: ./scripts/completions.sh
# Output: completions/ directory with shell-specific files

set -e

# Create completions directory
rm -rf completions
mkdir -p completions

echo "Generating shell completions..."

# Generate completions for each shell
for sh in bash zsh fish; do
    echo "  - $sh"
    go run ./cmd/__PROJECT_NAME__ completion "$sh" > "completions/gz-__PROJECT_NAME__.$sh"
done

echo "Shell completions generated successfully in completions/"
