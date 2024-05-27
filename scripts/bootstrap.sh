#!/bin/sh

cd "$(dirname "$(realpath "$0")")/../" || exit 255

echo "$(date): Updating submodules..."
git submodule update --init --recursive 2>&1 | while read -r LOGLINE; do echo "$(date): ${LOGLINE}"; done
