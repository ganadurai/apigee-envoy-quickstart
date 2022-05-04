#!/bin/bash

echo "Downloading required libraries from Apigee to configure Envoy adapter"

cd $ENVOY_HOME


wget https://github.com/apigee/apigee-remote-service-cli/releases/download/v${APIGEE_REMOTE_SRVC_CLI_VERSION}/apigee-remote-service-cli_${APIGEE_REMOTE_SRVC_CLI_VERSION}_linux_64-bit.tar.gz \
>/dev/null
RESULT=$?
if [ $RESULT -ne 0 ]; then
  echo "please verify the version number provided for /apigee-remote-service-cli"
  exit 1
fi

wget https://github.com/apigee/apigee-remote-service-envoy/releases/download/v${APIGEE_REMOTE_SRVC_ENVOY_VERSION}/apigee-remote-service-envoy_${APIGEE_REMOTE_SRVC_ENVOY_VERSION}_linux_64-bit.tar.gz \
>/dev/null
RESULT=$?
if [ $RESULT -ne 0 ]; then
  echo "please verify the version number provided for apigee-remote-service-envoy"
  exit 1
fi

tar -xf apigee-remote-service-cli_${APIGEE_REMOTE_SRVC_CLI_VERSION}_linux_64-bit.tar.gz \
-C apigee-remote-service-cli
tar -xf apigee-remote-service-envoy_${APIGEE_REMOTE_SRVC_ENVOY_VERSION}_linux_64-bit.tar.gz \
-C apigee-remote-service-envoy

cd $CLI_HOME

echo ""
echo ""
echo ""
echo "Provisioning the apigee remote service"
$CLI_HOME/apigee-remote-service-cli provision \
--organization $ORG \
--environment $ENV \
--runtime $RUNTIME \
--namespace $NAMESPACE \
--analytics-sa $AX_SERVICE_ACCOUNT \
--token $TOKEN > config.yaml

kubectl --context=${CLUSTER_CTX} -n $NAMESPACE apply -f $CLI_HOME/config.yaml

curl -i -v $RUNTIME/remote-token/certs | grep 200 2>&1 >/dev/null
RESULT=$?
if [ $RESULT -ne 0 ]; then
  echo "FAILED : Not success in provisioning the apigee adapter proxies to the mgmt plane"
  exit 1
fi

echo ""
echo ""
echo ""
echo "Creating the sample application, envoy-filter and apigee-adapter yaml files"
$CLI_HOME/apigee-remote-service-cli samples create -c ./config.yaml \
--out $ENVOY_CONFIGS_HOME --template istio-1.12

echo "Fixing the generated yaml files to use the namespace user provided"

cd $ENVOY_CONFIGS_HOME
sed -i "s/namespace: default/namespace: ${NAMESPACE}/g" $ENVOY_CONFIGS_HOME/httpbin.yaml
sed -i "s/namespace: default/namespace: ${NAMESPACE}/g" $ENVOY_CONFIGS_HOME/request-authentication.yaml
sed -i "s/namespace: default/namespace: ${NAMESPACE}/g" $ENVOY_CONFIGS_HOME/envoyfilter-sidecar.yaml

kubectl --context=${CLUSTER_CTX} -n $NAMESPACE apply -f httpbin.yaml

#echo "Testing the sample application (httpbin) accessing via service endpoint."
#echo "Since the cluster is ASM enabled, all the requests targetted to service endpoints is prox'd thru Envoy sidecar proxy"
#echo "Without the Apigee Envoy service (Envoy Filter) is enabled, the requests to httpbin service is unprotected"

printf "\n\nTesting the httpbin application\n"
kubectl --context=${CLUSTER_CTX} -n $NAMESPACE run -it --rm --image=curlimages/curl --restart=Never curl \
    --overrides='{ "apiVersion": "v1", "metadata": {"annotations": { "sidecar.istio.io/inject":"false" } } }' \
    -- curl -i httpbin.apigee.svc.cluster.local/headers | grep 200 \
2>&1 >/dev/null
RESULT=$?
if [ $RESULT -ne 0 ]; then
  printf "Access to httpbin ClusterIP endpoint fails, pre-enabling of envoy filter that enforces Apigee authentication this test should succeed"
  exit 1
fi

printf "Successfully tested the sample httpbin application"



