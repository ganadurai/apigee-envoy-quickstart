#!/bin/bash

# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

export PROJECT_ID='apigee-envoy-1'
export ACCOUNT_ID='admin@ganadurai.altostrat.com'

gcloud config set account $ACCOUNT_ID
gcloud config set project $PROJECT_ID
gcloud auth login

#The variables set by pipeline runner at automation time
export APIGEE_X_ORG="x-project-1-344916"
export APIGEE_X_ENV=eval
export APIGEE_X_HOSTNAME=https://34.107.231.171.nip.io


export ENVOY_HOME=/tmp
export CLUSTER_NAME="gke-central-3"
export CLUSTER_LOCATION="us-central1"
export COMPUTE_ZONE=${CLUSTER_LOCATION}-b

export APIGEE_PROJECT_ID=$APIGEE_X_ORG
export APIGEE_REMOTE_SRVC_CLI_VERSION=2.0.5
export APIGEE_REMOTE_SRVC_ENVOY_VERSION=2.0.5

export TOKEN=$(gcloud auth print-access-token);echo $TOKEN

gcloud container clusters list | grep $CLUSTER_NAME \
  2>&1 >/dev/null
RESULT=$?

if [ $RESULT -ne 0 ]; then
  printf "Cluster with name does not exist, so creating"
  export NETWORK_NAME=$(gcloud compute networks list --format json | jq -r '.[0].name')
  export SUBNETWORK_NAME=$(gcloud compute networks subnets list --format json | jq -r '.[0].name')
  printf "\nNetwork Name = $NETWORK_NAME"
  printf "\nSubNetwork Name = $SUBNETWORK_NAME"

  gcloud container clusters create $CLUSTER_NAME \
  --project=$PROJECT_ID --zone=$CLUSTER_LOCATION \
  --machine-type=e2-standard-4 --num-nodes=2 \
  --network=$NETWORK_NAME \
  --subnetwork=$SUBNETWORK_NAME \
    2>&1 >/dev/null
  CLUSTER_CREATE_RESULT=$?
  if [ $CLUSTER_CREATE_RESULT -ne 0 ]; then
    printf "Issue with creating a cluster, exiting"
    exit 1;
  fi
else
  printf "Cluster with name exist"
fi

#The pipeline docker image should be updated to have this pre-packaged
gcloud components install kubectl --quiet

printf "Running envoy cleanup"
./aekitctl.sh --type istio-apigee-envoy --action delete

printf "Running envoy setup"
./aekitctl.sh --type istio-apigee-envoy --action install







