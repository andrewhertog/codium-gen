#!/usr/bin/env bash
set -x

cd $(dirname $0)
npm install
npx gulp
