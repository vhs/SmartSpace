#!/bin/sh

echo "Copying missing .env files"
find env -type f -name '*.sample.env' | while read sampleenv; do
    envfile=$(echo "$sampleenv" | sed 's/\.sample\.env/.env/g')
    if [ ! -f "$envfile" ]; then
        echo "Copying $sampleenv to $envfile"
        cp "$sampleenv" "$envfile"
    fi
done

echo "Updating containers..."
docker-compose up --remove-orphans -d
