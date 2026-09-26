#!/bin/bash

set -e

cd "$(dirname "$0")"

wait_for_zulip() {
  local timeout=600
  local start=$SECONDS
  echo "Waiting for Zulip server to start..."
  while [ "$(curl -k -L -s -o /dev/null -w "%{http_code}" http://localhost/login)" != "200" ]
  do
    if [ $((SECONDS - start)) -ge $timeout ]; then
      echo "Timed out after ${timeout}s waiting for Zulip server to start"
      exit 1
    fi
    sleep 5
  done
  echo "Zulip server started after $((SECONDS - start))s"
}

echo "Starting Zulip containers"
docker compose up -d
wait_for_zulip

echo "Populating Zulip database"
./populatedb.sh
wait_for_zulip

echo "Creating zuliprc"
./createzuliprc.sh

echo "Zulip setup complete"
