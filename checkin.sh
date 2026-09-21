#!/bin/sh
# Add all files, commit with the message passed as the first argument, and push to the main branch of the repository using the provided GitHub username and password for authentication.
git add .;git commit -m "$1";git push https://$USERNAME:$PASSWORD@github.com/codeWriter9/sovereign-shell-scripts.git main