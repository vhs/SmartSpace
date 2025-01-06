#!/bin/sh

set -e

cd "$(dirname "$(realpath "$0")")/" || exit 255

echo "$(date): Deploying vhs-smartspace..."

./scripts/bootstrap.sh

./scripts/lint.sh

echo "$(date): Updating containers..."
docker compose pull -q 2>&1 | while read -r LOGLINE; do echo "$(date): $LOGLINE"; done
docker compose up --remove-orphans -d 2>&1 | while read -r LOGLINE; do echo "$(date): $LOGLINE"; done

echo "$(date): Done!"
