#!/usr/bin/env bash

mkdir -p vscodium
cd vscodium
git init -q
git remote add origin https://github.com/VSCodium/vscodium.git
git remote add dest https://github.com/andrewhertog/codex.git

git fetch origin
git checkout 1.97.0.25037
TAG=update/$(date +%Y-%m-%d-%H-%M-%S)
git switch -c $TAG

git pull dest master --allow-unrelated-histories -X theirs

# gh pr create --repo andrewhertog/codex --base master
