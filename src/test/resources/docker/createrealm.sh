#!/bin/bash

docker compose exec -u zulip zulip /home/zulip/deployments/current/manage.py generate_realm_creation_link
