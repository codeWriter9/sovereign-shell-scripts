#!/bin/bash
# Usage: ./git-purge-branches.sh

echo "Fetching latest remote state..."
git fetch -p

echo "Switching to main..."
git checkout main && git pull origin main

echo "Pruning merged local branches..."
# Lists branches merged to main, excludes main/master, and deletes them
git branch --merged | grep -vE '^\*|main|master' | xargs -r git branch -d

echo "Remaining local branches:"
git branch -v