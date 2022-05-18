#!/bin/bash

set -e

echo "Extract the consumer key"

export CONSUMER_KEY=$(curl -H "Authorization: ${TOKEN_TYPE} ${TOKEN}"  \
    -H "Content-Type:application/json" \
    "${MGMT_HOST}/v1/organizations/${ORG}/developers/test-envoy@google.com/apps/envoy-adapter-app-2" | \
    jq '.credentials[0].consumerKey'); \
    export CONSUMER_KEY=$(echo $CONSUMER_KEY|cut -d '"' -f 2); \
    echo "" && echo ""

echo "Wait for few minutes for the Envoy and Apigee adapter to have the setup completed. Then try the below command"

echo ""

echo kubectl --context=${CLUSTER_CTX} -n $NAMESPACE run -it --rm --image=curlimages/curl --restart=Never curl \
    --overrides=\'{\"apiVersion\":\"v1\", \"metadata\":{\"annotations\": { \"sidecar.istio.io/inject\":\"false\" } } }\' \
    -- curl -i httpbin.apigee.svc.cluster.local/headers -H "\"x-api-key: $CONSUMER_KEY\""

echo ""

echo "Try with and without sending the x-api-key header, this proves the httpbin service is intercepted by the Envoy sidecar which has the Envoy filter configured to connect to Apigee adapter running as container that executes the key verification with the Apigee runtime"

echo ""
