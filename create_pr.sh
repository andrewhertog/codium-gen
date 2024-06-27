#!/usr/bin/env bash

cd vscodium

git remote show dest
if [[ "$?" == "0" ]]; then
    git remote set-url dest https://github.com/andrewhertog/codex.git
else
    git remote add dest https://github.com/andrewhertog/codex.git
fi
git fetch 

TAG=update/$(date +%s)
git switch -c $TAG
git commit -a -m "updates"

git push dest $TAG

