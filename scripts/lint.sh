#!/bin/sh

cd "$(dirname "$(realpath "$0")")/../" || exit 255

if [ "$(find env -type f -name '*.sample.env' | wc -l)" != "$(find env -type f -name '*.env' | egrep -vw sample | wc -l)" ]; then
    echo "$(date): Copying missing .env files"
    find env -type f -name '*.sample.env' | while read -r SAMPLEENV; do
        ENVFILE=$(echo "${SAMPLEENV}" | sed 's/\.sample\.env/.env/g')

        if [ ! -f "$ENVFILE" ]; then
            echo "$(date): Copying $SAMPLEENV to ${ENVFILE}"
            cp "${SAMPLEENV}" "${ENVFILE}"
        fi
    done
fi

if [ ! -f .env ]; then
    echo "$(date): Missing .env file"

    touch .env
fi

if [ ! -f docker-compose.yml ]; then
    echo "$(date): Missing docker-compose.yml file"

    touch docker-compose.yml
fi

if [ "$(grep -E '^COMPOSE_FILE' .env)" = "" ]; then
    echo "$(date): Missing COMPOSE_FILE .env variable"

    echo "COMPOSE_FILE=docker-compose.yml:$(find docker/ -maxdepth 1 -type f -name 'docker-compose.*.yml' | sort | xargs | tr ' ' ':')" >>.env
fi

if [ -f docker-compose.override.yml ] && [ "$(grep -E '^COMPOSE_FILE=.*docker-compose.override.yml' .env)" = "" ]; then
    echo "$(date): Missing docker-compose.override.yml in COMPOSE_FILE variable"

    perl -pe 's/(COMPOSE_FILE=.+)/$1:docker-compose.override.yml/g' -i .env
fi
