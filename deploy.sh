#!/bin/sh

BASEDIR="$( cd $(dirname $0)/$(if [ "$(find $0 -type l)" != "" ]; then dirname $(find $0 -printf '%l'); fi) ; pwd )"

cd "$BASEDIR"

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
