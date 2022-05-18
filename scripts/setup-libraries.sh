#!/bin/bash

set -e

cd $CLI_HOME

printf "\n\n\nProvisioning the apigee remote service\n"

if [ $INSTALL_TYPE == 'istio-apigee-envoy' ]
then
    $CLI_HOME/apigee-remote-service-cli provision \
    --organization $ORG \
    --environment $ENV \
    --runtime $RUNTIME \
    --namespace $NAMESPACE \
    --analytics-sa $AX_SERVICE_ACCOUNT \
    --token $TOKEN > $CLI_HOME/config.yaml
else
    $CLI_HOME/apigee-remote-service-cli provision \
    --organization $ORG \
    --environment $ENV \
    --management $MGMT_HOST \
    --username $USER \
    --password $PASSWORD \
    --opdk --verbose > $CLI_HOME/config.yaml
fi

curl -i -v $RUNTIME/remote-token/certs | grep 200 2>&1 >/dev/null
RESULT=$?
if [ $RESULT -ne 0 ]; then
  echo "FAILED : Not success in provisioning the apigee adapter proxies to the mgmt plane"
  exit 1
fi

printf "\n\n\nCreating the sample application, envoy-filter and apigee-adapter yaml files"
$CLI_HOME/apigee-remote-service-cli samples create -c ./config.yaml \
--out $ENVOY_CONFIGS_HOME --template $TEMPLATE



