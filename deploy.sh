#!/bin/sh

BASEDIR="$(cd $(dirname $0)/$(if [ "$(find $0 -type l)" != "" ]; then dirname $(find $0 -printf '%l'); fi) ; pwd)"

cd "$BASEDIR"

echo "$(date): Deploying vhs-smartspace..."

echo "$(date): Updating submodules..."
git submodule update --init --recursive 2>&1 | while read logline ; do echo "$(date): $logline" ; done

echo "$(date): Copying missing .env files"
find env -type f -name '*.sample.env' | while read sampleenv; do
        envfile=$(echo "$sampleenv" | sed 's/\.sample\.env/.env/g')
        if [ ! -f "$envfile" ]; then
                echo "$(date): Copying $sampleenv to $envfile"
                cp "$sampleenv" "$envfile"
        fi
done

echo "$(date): Updating containers..."
docker-compose pull 2>&1 | while read logline ; do echo "$(date): $logline" ; done
docker-compose up --remove-orphans -d 2>&1 | while read logline ; do echo "$(date): $logline" ; done

echo "$(date): Done!"
