#!/bin/bash

BASEDIR="$(dirname "$(realpath "$0")")"

cd "$BASEDIR" || exit 255

echo "$(date): Checking vhs-smartspace..."

docker-compose up --remove-orphans -d 2>&1 | while read -r dclog; do
    echo "$(date): $dclog"
done

echo "$(date): Done!"
