#!/bin/bash

set -e

if [[ -z $ORG ]]; then
    echo "Environment variable ORG is not set, please checkout README.md"
    exit 1
fi

if [[ -z $ENV ]]; then
    echo "Environment variable ENV is not set, please checkout README.md"
    exit 1
fi

if [[ -z $RUNTIME ]]; then
    echo "Environment variable RUNTIME is not set, please checkout README.md"
    exit 1
fi

if [[ -z $APIGEE_REMOTE_SRVC_CLI_VERSION ]]; then
    echo "Environment variable APIGEE_REMOTE_SRVC_CLI_VERSION is not set, please checkout https://github.com/apigee/apigee-remote-service-cli/releases/latest"
    exit 1
fi

if [[ -z $APIGEE_REMOTE_SRVC_ENVOY_VERSION ]]; then
    echo "Environment variable APIGEE_REMOTE_SRVC_ENVOY_VERSION is not set, please checkout https://github.com/apigee/apigee-remote-service-envoy/releases/latest"
    exit 1
fi

#Validate the Apigee org and env

curl -i -H "Authorization: ${TOKEN_TYPE} ${TOKEN}" \
"${MGMT_HOST}/v1/organizations/${ORG}" \
2>&1 >/dev/null
RESULT=$?
if [ $RESULT -ne 0 ]; then
  echo "please verify the provided values about Apigee"
  exit 1
fi

#Validate the Apigee virtualhost reachability
#TODO

echo "Validation successful.."