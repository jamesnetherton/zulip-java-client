#!/bin/bash
#
# Migrates zulip.sql to the schema of the Zulip server image configured in docker-compose.yml.
#
# Starts a clean stack, loads the existing zulip.sql, restarts so that the Zulip container applies
# its database migrations, verifies the server version, dumps the database back to zulip.sql and
# then checks the test user can log in. The dump is taken before any tests run so it contains no test data.
#
# Usage: refreshdb.sh [expected-zulip-version]   e.g. refreshdb.sh 13.0

set -euo pipefail

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

migration_count() {
  awk '/^COPY zulip.django_migrations /{f=1; next} f && /^\\\./{exit} f' "$1" | wc -l | tr -d ' '
}

IMAGE_TAG=$(sed -n "s/.*image: *['\"]*ghcr.io\/zulip\/zulip-server:\([^'\"]*\).*/\1/p" docker-compose.yml)
IMAGE_VERSION=${IMAGE_TAG%-*}
EXPECTED_VERSION=${1:-${IMAGE_VERSION}}

if [ "${IMAGE_VERSION}" != "${EXPECTED_VERSION}" ]; then
  echo "docker-compose.yml uses zulip-server:${IMAGE_TAG} but ${EXPECTED_VERSION} was expected. Bump the image first."
  exit 1
fi

OLD_DUMP=$(mktemp)
cp zulip.sql "${OLD_DUMP}"
trap 'rm -f "${OLD_DUMP}"' EXIT

echo "Starting a clean Zulip ${IMAGE_TAG} stack"
docker compose down --volumes --remove-orphans
docker compose pull --quiet
docker compose up -d
wait_for_zulip

echo "Loading existing zulip.sql and restarting to apply migrations"
./populatedb.sh
wait_for_zulip

echo "Checking for unapplied migrations"
UNAPPLIED=$(docker compose exec -T -u zulip zulip /home/zulip/deployments/current/manage.py showmigrations --plan | grep -c '^\[ \]' || true)
if [ "${UNAPPLIED}" != "0" ]; then
  echo "${UNAPPLIED} migrations were not applied. Check: docker compose logs zulip"
  exit 1
fi

# Read from version.py rather than the API, since API requests write to the database
VERSION_PY=$(docker compose exec -T zulip cat /home/zulip/deployments/current/version.py)
SERVER_VERSION=$(echo "${VERSION_PY}" | sed -n 's/^ZULIP_VERSION = "\(.*\)"/\1/p' | head -1)
FEATURE_LEVEL=$(echo "${VERSION_PY}" | sed -n 's/^API_FEATURE_LEVEL = \([0-9]*\).*/\1/p')
if [[ "${SERVER_VERSION}" != "${EXPECTED_VERSION}"* ]]; then
  echo "Server reports Zulip ${SERVER_VERSION}, expected ${EXPECTED_VERSION}"
  exit 1
fi

echo "Dumping database"
./regenerate.sh
if ! grep -A1 -x 'DROP SCHEMA IF EXISTS zulip CASCADE;' zulip.sql | grep -qx 'CREATE SCHEMA zulip;'; then
  echo "zulip.sql is missing 'DROP SCHEMA IF EXISTS zulip CASCADE;' before 'CREATE SCHEMA zulip;'"
  exit 1
fi

# Logging in writes to the database, so check it after dumping to keep the dump clean
echo "Checking test user login"
API_KEY=$(curl -k -s -X POST --data-urlencode 'username=test@test.com' --data-urlencode 'password=testing123!' \
  https://localhost/api/v1/fetch_api_key | jq -r '.api_key // empty')
if [ -z "${API_KEY}" ]; then
  echo "test@test.com could not log in to the migrated database"
  exit 1
fi

echo
echo "Refreshed zulip.sql for Zulip ${SERVER_VERSION} (feature level ${FEATURE_LEVEL})"
echo "Applied migrations: $(migration_count "${OLD_DUMP}") -> $(migration_count zulip.sql)"
