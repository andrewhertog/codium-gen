#!/usr/bin/env bash

mkdir -p vscodium
cd vscodium
git init -q
git remote add origin https://github.com/VSCodium/vscodium.git

git fetch --depth 1 origin master
git checkout FETCH_HEAD


