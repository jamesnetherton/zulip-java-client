#!/bin/bash

cd $(dirname $(find /home/zulip/deployments -name manage.py))
su zulip -c './manage.py change_user_role test@test.com can_create_users --realm=2'
