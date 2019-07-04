#!/bin/bash
  
BASEDIR="$( cd $(dirname $0)/$(if [ "$(find $0 -type l)" != "" ]; then dirname $(find $0 -printf '%l'); fi) ; pwd )"

cd "$BASEDIR"

echo "$(date): Checking vhs-smartspace..."

docker-compose up --remove-orphans -d 2>&1 | while read dclog
do
        echo "$(date): $dclog"
done

echo "$(date): Done!"
