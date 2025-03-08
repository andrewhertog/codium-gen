#!/usr/bin/env bash
set -x

LC_ALL=C

cd vscodium

LABEL="codex"
TITLE="Codex"
FULLNAME="Codex"
DEST_REPO="BiblioNexus-Foundation/codex"
URL="www.codex.bible"

# Update git repository
find . -type  f -not -path '*/\.git/*'  -exec sed -i '' -e "s|https://github.com/VSCodium/vscodium|https://github.com/${DEST_REPO}|g" '{}' \;
find . -type  f -not -path '*/\.git/*' -exec sed -i '' -e "s|VSCodium/vscodium|${DEST_REPO}|g" '{}' \;

find . -type  f -not -path '*/\.git/*' -exec sed -i '' -e "s|www.vscodium.com|${URL}|g" '{}' \;



# Bulk updating 
find . -type  f -not -path '*/\.git/*' -exec sed -i '' -e "s/VSCodium/${TITLE}/g" '{}' \;
find . -type  f -not -path '*/\.git/*' -exec sed -i '' -e "s/Codium/${TITLE}/g" '{}' \;
find . -type  f -not -path '*/\.git/*' -exec sed -i '' -e "s/vscodium/${LABEL}/g" '{}' \;
find . -type  f -not -path '*/\.git/*' -exec sed -i '' -e "s/codium/${LABEL}/g" '{}' \;

# Fixing backwards
find . -type  f -not -path '*/\.git/*' -exec sed -i '' -e "s|${LABEL}/${LABEL}-linux-build-agent|vscodium/vscodium-linux-build-agent|g" '{}' \;
find . -type  f -not -path '*/\.git/*' -exec sed -i '' -e "s|${TITLE}/vscode-linux-build-agent|VSCodium/vscode-linux-build-agent|g" '{}' \;


cp ../extra-files/*  .

mv build/windows/msi/includes/vscodium-variables.wxi build/windows/msi/includes/${LABEL}-variables.wxi
mv build/windows/msi/vscodium.wxs build/windows/msi/${LABEL}.wxs
mv build/windows/msi/vscodium.xsl build/windows/msi/${LABEL}.xsl

mv build/windows/msi/i18n/vscodium.de-de.wxl build/windows/msi/i18n/${LABEL}.de-de.wxl
mv build/windows/msi/i18n/vscodium.en-us.wxl build/windows/msi/i18n/${LABEL}.en-us.wxl
mv build/windows/msi/i18n/vscodium.es-es.wxl build/windows/msi/i18n/${LABEL}.es-es.wxl
mv build/windows/msi/i18n/vscodium.fr-fr.wxl build/windows/msi/i18n/${LABEL}.fr-fr.wxl
mv build/windows/msi/i18n/vscodium.it-it.wxl build/windows/msi/i18n/${LABEL}.it-it.wxl
mv build/windows/msi/i18n/vscodium.ja-jp.wxl build/windows/msi/i18n/${LABEL}.ja-jp.wxl
mv build/windows/msi/i18n/vscodium.ko-kr.wxl build/windows/msi/i18n/${LABEL}.ko-kr.wxl
mv build/windows/msi/i18n/vscodium.ru-ru.wxl build/windows/msi/i18n/${LABEL}.ru-ru.wxl
mv build/windows/msi/i18n/vscodium.zh-cn.wxl build/windows/msi/i18n/${LABEL}.zh-cn.wxl
mv build/windows/msi/i18n/vscodium.zh-tw.wxl build/windows/msi/i18n/${LABEL}.zh-tw.wxl

rm .github/workflows/insider-*
rm .github/workflows/lock.yml
rm .github/workflows/stale.yml
rm .github/workflows/stable-spearhead.yml

rm icons/stable/codium*

cp -rf ../icons/* src/stable/resources/