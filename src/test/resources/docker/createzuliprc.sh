#!/bin/sh

API_KEY=$(curl -k -s -S -X POST --data-urlencode 'username=test@test.com' --data-urlencode 'password=testing123' https://localhost/api/v1/fetch_api_key | jq -r '.api_key')

echo "key=${API_KEY}\nemail=test@test.com\nsite=https://localhost\ninsecure=true" > ../../../../zuliprc
