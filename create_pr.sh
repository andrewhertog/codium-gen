#!/usr/bin/env bash

cd vscodium
mv .gitignore .gitignore.bak
git remote show dest
if [[ "$?" == "0" ]]; then
    git remote set-url dest https://github.com/andrewhertog/codex.git
else
    git remote add dest https://github.com/andrewhertog/codex.git
fi
git fetch 

TAG=update/$(date +%s)
git switch -c $TAG
git add -A
git commit -a -m "updates"

git push dest $TAG

