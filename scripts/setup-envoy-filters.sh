#!/bin/bash

set -e

cd $ENVOY_CONFIGS_HOME

kubectl --context=${CLUSTER_CTX} apply -f request-authentication.yaml
kubectl --context=${CLUSTER_CTX} apply -f envoyfilter-sidecar.yaml
