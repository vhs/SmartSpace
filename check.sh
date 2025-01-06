#!/bin/bash

set -e

cd "$(dirname "$(realpath "$0")")/" || exit 255

./scripts/lint.sh

echo "$(date): Checking vhs-smartspace..."

docker compose up --remove-orphans -d 2>&1 | while read -r DCLOG; do
    echo "$(date): ${DCLOG}"
done

echo "$(date): Done!"
