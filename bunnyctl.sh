#!/bin/bash

#telepresence login --apikey=KEY

#bunnyctl dev --environment <env-id> --component frontend --docker demoapp --mount ./myapp:/var/www

# service_name="web-python"
# environment_name="env-kqcjip"

command="$1"

if [ -z "$command" ]
then
      if [ -z "$service_name" ]
      then
      #   echo -e "service name: "; read service_name;
            read -p $'\033[0;33mservice name: \033[00m' service_name
      fi
      
      environment_name=$(kubectl config view --minify -o jsonpath='{..namespace}')

      if [ -z "$environment_name" ]
      then
            read -p $'\033[0;33menvironment_name: \033[00m' environment_name;
      fi
      echo "Connecting $service_name to: $environment_name"

      # service_name="web-python";environment_name="env-kqcjip";telepresence intercept $service_name --port 80:80 -n $environment_name
      telepresence intercept $service_name --port 80:80 -n $environment_name

fi

if [ "$command" = "disconnect" ]; then

      echo -e "disconnecting: $service_name from: $environment_name"

fi











