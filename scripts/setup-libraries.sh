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

set -e

INSTALL_SCRIPTS_DIR=$(pwd)

cd $CLI_HOME

printf "\n\n\nProvisioning the apigee remote service\n"

if [ "$PLATFORM" == 'opdk' ]
then
    $CLI_HOME/apigee-remote-service-cli provision \
    --organization $APIGEE_ORG \
    --environment $APIGEE_ENV \
    --runtime $APIGEE_X_HOSTNAME \
    --management $MGMT_HOST \
    --username $APIGEE_USER \
    --password $APIGEE_PASS \
    --opdk --verbose > $CLI_HOME/config.yaml
else
    $CLI_HOME/apigee-remote-service-cli provision \
    --organization $APIGEE_ORG \
    --environment $APIGEE_ENV \
    --runtime $APIGEE_X_HOSTNAME \
    --namespace $NAMESPACE \
    --analytics-sa $AX_SERVICE_ACCOUNT \
    --token $TOKEN > $CLI_HOME/config.yaml

sed -i "s/      collection_interval: 10s/      collection_interval: 10s\r    products:\r      refresh_rate: 2s\r/g" $CLI_HOME/config.yaml

fi

curl -i -v $APIGEE_X_HOSTNAME/remote-token/certs | grep 200 2>&1 >/dev/null
RESULT=$?
if [ $RESULT -ne 0 ]; then
  echo "FAILED : Not success in provisioning the apigee adapter proxies to the mgmt plane"
  exit 1
fi

printf "\n\n\nCreating the sample application, envoy-filter and apigee-adapter yaml files"
$CLI_HOME/apigee-remote-service-cli samples create -c ./config.yaml \
--out $ENVOY_CONFIGS_HOME --template $TEMPLATE



