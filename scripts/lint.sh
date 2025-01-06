#!/bin/sh

set -e

cd "$(dirname "$(realpath "$0")")/../" || exit 255

if [ "$(find conf -type f -name '*sample*' | wc -l)" != "$(find conf -type f -name '*sample*' | sed 's:\.sample::g' | xargs ls 2>/dev/null | wc -l)" ]; then
    echo "$(date): Copying missing conf files"
    find conf -type f -name '*sample*' | while read -r SAMPLECONF; do
        CONFFILE=$(echo "${SAMPLECONF}" | sed 's:\.sample::g')

        if [ ! -f "$CONFFILE" ]; then
            echo "$(date): Copying $SAMPLECONF to ${CONFFILE}"
            cp "${SAMPLECONF}" "${CONFFILE}"
        fi
    done
fi

if [ "$(find env -type f -name '*.sample.env' | wc -l)" != "$(find env -type f -name '*.env' | grep -v -E 'woodshopdustplc-data-bridge-(local|stats|destination)' | grep -E -c -vw sample)" ]; then
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

if [ ! -f conf/mosquitto-auth/dynamic-security.json ]; then
    echo "$(date): Please generate missing conf/mosquitto-auth/dynamic-security.json file manually! Bailing..."
    exit 254
fi
