#!/usr/bin/env bash

mkdir -p vscodium
cd vscodium
git init -q
git remote add origin https://github.com/VSCodium/vscodium.git
git remote add dest https://github.com/andrewhertog/codex.git

git fetch --depth 1 origin master
git checkout master
git checkout -b test

git pull dest master --allow-unrelated-histories -X theirs
