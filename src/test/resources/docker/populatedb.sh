#!/bin/bash

docker cp ./reload.sh $(docker compose ps -q database):/reload.sh
docker cp ./zulip.sql $(docker compose ps -q database):/zulip.sql
docker exec $(docker compose ps -q database) /bin/bash /reload.sh
docker compose stop
docker compose start
