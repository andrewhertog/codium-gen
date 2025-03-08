#!/usr/bin/env bash
set -x

export LC_ALL=en_US.UTF-8

cd vscodium

LABEL="codex"
TITLE="Codex"
FULLNAME="Codex"
DEST_REPO="BiblioNexus-Foundation/codex"
URL="www.codex.bible"

# Add exclusions for icon files to all find commands
FIND_EXCLUDE="-not -path '*/\.git/*' -not -name '*.ico' -not -name '*.icns'"

# Update git repository
find . -type f ${FIND_EXCLUDE} -exec sed -i '' -e "s|https://github.com/VSCodium/vscodium|https://github.com/${DEST_REPO}|g" '{}' \;
find . -type f ${FIND_EXCLUDE} -exec sed -i '' -e "s|VSCodium/vscodium|${DEST_REPO}|g" '{}' \;

find . -type f ${FIND_EXCLUDE} -exec sed -i '' -e "s|www.vscodium.com|${URL}|g" '{}' \;

# Bulk updating 
find . -type f ${FIND_EXCLUDE} -exec sed -i '' -e "s/VSCodium/${TITLE}/g" '{}' \;
find . -type f ${FIND_EXCLUDE} -exec sed -i '' -e "s/Codium/${TITLE}/g" '{}' \;
find . -type f ${FIND_EXCLUDE} -exec sed -i '' -e "s/vscodium/${LABEL}/g" '{}' \;
find . -type f ${FIND_EXCLUDE} -exec sed -i '' -e "s/codium/${LABEL}/g" '{}' \;

# Fixing backwards
find . -type f ${FIND_EXCLUDE} -exec sed -i '' -e "s|${LABEL}/${LABEL}-linux-build-agent|vscodium/vscodium-linux-build-agent|g" '{}' \;
find . -type f ${FIND_EXCLUDE} -exec sed -i '' -e "s|${TITLE}/vscode-linux-build-agent|VSCodium/vscode-linux-build-agent|g" '{}' \;

cp ../extra-files/*  .

# File moves with existence checks
for file in \
    "build/windows/msi/includes/vscodium-variables.wxi:build/windows/msi/includes/${LABEL}-variables.wxi" \
    "build/windows/msi/vscodium.wxs:build/windows/msi/${LABEL}.wxs" \
    "build/windows/msi/vscodium.xsl:build/windows/msi/${LABEL}.xsl" \
    "build/windows/msi/i18n/vscodium.de-de.wxl:build/windows/msi/i18n/${LABEL}.de-de.wxl" \
    "build/windows/msi/i18n/vscodium.en-us.wxl:build/windows/msi/i18n/${LABEL}.en-us.wxl" \
    "build/windows/msi/i18n/vscodium.es-es.wxl:build/windows/msi/i18n/${LABEL}.es-es.wxl" \
    "build/windows/msi/i18n/vscodium.fr-fr.wxl:build/windows/msi/i18n/${LABEL}.fr-fr.wxl" \
    "build/windows/msi/i18n/vscodium.it-it.wxl:build/windows/msi/i18n/${LABEL}.it-it.wxl" \
    "build/windows/msi/i18n/vscodium.ja-jp.wxl:build/windows/msi/i18n/${LABEL}.ja-jp.wxl" \
    "build/windows/msi/i18n/vscodium.ko-kr.wxl:build/windows/msi/i18n/${LABEL}.ko-kr.wxl" \
    "build/windows/msi/i18n/vscodium.ru-ru.wxl:build/windows/msi/i18n/${LABEL}.ru-ru.wxl" \
    "build/windows/msi/i18n/vscodium.zh-cn.wxl:build/windows/msi/i18n/${LABEL}.zh-cn.wxl" \
    "build/windows/msi/i18n/vscodium.zh-tw.wxl:build/windows/msi/i18n/${LABEL}.zh-tw.wxl"
do
    SOURCE="${file%%:*}"
    DEST="${file#*:}"
    if [ -f "$SOURCE" ]; then
        mv "$SOURCE" "$DEST"
    fi
done

# File removals with existence checks
for pattern in \
    ".github/workflows/insider-*" \
    ".github/workflows/lock.yml" \
    ".github/workflows/stale.yml" \
    ".github/workflows/stable-spearhead.yml" \
    "icons/stable/codium*"
do
    if ls $pattern 1> /dev/null 2>&1; then
        rm $pattern
    fi
done

# Copy icons if source directory exists
if [ -d "../icons" ]; then
    cp -rf ../icons/* src/stable/resources/
fi
