#!/usr/bin/env bash

LC_ALL=C

cd vscodium

LABEL="codex"
TITLE="Codex"
FULLNAME="Codex"
DEST_REPO="andrewhertog/codex"
URL="www.codex.bible"

# Update git repository
find . -not -path '*/\.git/*'  -exec sed -i '' -e "s|https://github.com/VSCodium/vscodium|https://github.com/${DEST_REPO}|g" '{}' \;
find . -not -path '*/\.git/*' -exec sed -i '' -e "s|VSCodium/vscodium|${DEST_REPO}|g" '{}' \;

find . -not -path '*/\.git/*' -exec sed -i '' -e "s|www.vscodium.com|${URL}|g" '{}' \;



# Bulk updating 
find . -not -path '*/\.git/*' -exec sed -i '' -e "s/VSCodium/${TITLE}/g" '{}' \;
find . -not -path '*/\.git/*' -exec sed -i '' -e "s/Codium/${TITLE}/g" '{}' \;
find . -not -path '*/\.git/*' -exec sed -i '' -e "s/vscodium/${LABEL}/g" '{}' \;
find . -not -path '*/\.git/*' -exec sed -i '' -e "s/codium/${LABEL}/g" '{}' \;

# Fixing backwards
find . -not -path '*/\.git/*' -exec sed -i '' -e "s|${LABEL}/${LABEL}-linux-build-agent|vscodium/vscodium-linux-build-agent|g" '{}' \;
find . -not -path '*/\.git/*' -exec sed -i '' -e "s|${TITLE}/vscode-linux-build-agent|VSCodium/vscode-linux-build-agent|g" '{}' \;

