#!/bin/bash

ENV_NAME=""

if [ -z "$BUNNYSHELL_API_TOKEN" ]
then
    echo -e "Please set the BUNNYSHELL_API_TOKEN"
    exit 1;
fi

if [ -z "$ENV_NAME" ]
then
    read -p $'\033[0;33mEnvironment name: \033[00m' ENV_NAME;
fi

  echo -e "creating environment: $ENV_NAME"

curl -X 'POST' \
  'https://api.environments.bunnyshell.com/api/environments' \
  -H 'accept: application/json' \
  -H 'X-Auth-Token: 397:ee27882ad16a84a019a359d58bbb9d0a' \
  -H 'Content-Type: application/ld+json' \
  -d '{
  "name": "string",
  "type": "string",
  "autoUpdate": true,
  "createEphemeralOnPrCreate": true,
  "destroyEphemeralOnPrClose": true,
  "project": "string",
  "kubernetesIntegration": "string",
  "ephemeralKubernetesIntegration": "string",
  "envYamlRepositoryLink": "string",
  "envYamlBranch": "string",
  "envYamlPath": "string"
}'