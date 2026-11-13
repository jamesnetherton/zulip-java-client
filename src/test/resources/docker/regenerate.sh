#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")"

docker compose exec -T database pg_dump -U zulip zulip \
  | tr -d '\r' \
  | awk '/^CREATE SCHEMA/ { print "DROP SCHEMA IF EXISTS zulip CASCADE;" } { print }' > zulip.sql.tmp
mv zulip.sql.tmp zulip.sql
