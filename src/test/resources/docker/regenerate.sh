#!/bin/bash

docker compose exec database pg_dump -U zulip zulip > zulip.sql
dos2unix ./zulip.sql
sed -i '/^CREATE SCHEMA.*/i DROP SCHEMA IF EXISTS zulip CASCADE;' zulip.sql
