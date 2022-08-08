#!/bin/bash

environment_to_clone=""
environment_number="3100"

environment_to_clone="$1"

ENV_NAME=""

if [ -z "$BUNNYSHELL_API_TOKEN" ]
then
    echo -e "Please set the BUNNYSHELL_API_TOKEN"
    exit 1;
fi

if [ -z "$ENV_NAME" ]
then
    read -p $'\033[0;33mCloned environment name: \033[00m' ENV_NAME;
fi

if [ -z "$environment_to_clone" ]
then
    environment_to_clone=$environment_number
fi

    echo -e "cloning environment: $environment_to_clone to $ENV_NAME"

# curl -X 'POST' \
#   'https://api.environments.bunnyshell.com/api/environments/3100/clone' \
#   -H 'accept: application/ld+json' \
#   -H "X-Auth-Token: $BUNNYSHELL_API_TOKEN" \
#   -H 'Content-Type: application/json' \
#   -d "{ "$ENV_NAME": "string" }"

curl -X 'POST' \
  'https://api.environments.bunnyshell.com/api/environments/3100/clone' \
  -H 'accept: application/ld+json' \
  -H "X-Auth-Token: $BUNNYSHELL_API_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "'$ENV_NAME'"
}'

curl -X 'POST' \
  'https://api.environments.bunnyshell.com/api/environments/3100/clone' \
  -H 'accept: application/ld+json' \
  -H "X-Auth-Token: $BUNNYSHELL_API_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "'$ENV_NAME-1'"
}'

curl -X 'POST' \
  'https://api.environments.bunnyshell.com/api/environments/3100/clone' \
  -H 'accept: application/ld+json' \
  -H "X-Auth-Token: $BUNNYSHELL_API_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "'$ENV_NAME-2'"
}'