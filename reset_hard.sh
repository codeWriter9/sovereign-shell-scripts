#!/bin/sh
echo "Resetting hard. ALL local changes will be lost. Remote will be fetched"
git reset --hard && git fetch && git checkout main && git pull origin main
