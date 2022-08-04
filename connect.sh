#!/bin/bash

#telepresence login --apikey=KEY

#bunnyctl dev --environment <env-id> --component frontend --docker demoapp --mount ./myapp:/var/www

# service_name="web-python"
# environment_name="env-kqcjip"

service_name="$1"
environment_name="$2"

if [ -z "$service_name" ]
then
    #   echo -e "service name: "; read service_name;
      read -p $'\033[0;33mservice name: \033[00m' service_name
fi

if [ -z "$environment_name" ]
then
      read -p $'\033[0;33menvironment_name: \033[00m' environment_name;
fi


echo "Connecting $service_name to remote server: $environment_name"

# service_name="web-python";environment_name="env-kqcjip";telepresence intercept $service_name --port 80:80 -n $environment_name
telepresence intercept $service_name --port 80:80 -n $environment_name