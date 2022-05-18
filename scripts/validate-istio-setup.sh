#!/bin/bash

set -e


if [[ -z $PROJECT_ID ]]; then
    echo "Environment variable PROJECT_ID is not set, please checkout README.md"
    exit 1
fi

if [[ -z $CLUSTER_NAME ]]; then
    echo "Environment variable CLUSTER_NAME is not set, please checkout README.md"
    exit 1
fi

if [[ -z $CLUSTER_LOCATION ]]; then
    echo "Environment variable CLUSTER_LOCATION is not set, please checkout README.md"
    exit 1
fi

if [[ -z $APIGEE_PROJECT_ID ]]; then
    echo "Environment variable APIGEE_PROJECT_ID is not set, please checkout README.md"
    exit 1
fi

if [[ -z $TOKEN ]]; then
    echo "Environment variable TOKEN is not set, please checkout README.md"
    exit 1
fi

#Validate the kubernetes cluster

gcloud --project=${PROJECT_ID} container clusters list \
    --filter="name~${CLUSTER_NAME}" >/dev/null
RESULT=$?
if [ $RESULT -ne 0 ]; then
  echo "please verify the provided values about GKE cluster"
  exit 1
fi