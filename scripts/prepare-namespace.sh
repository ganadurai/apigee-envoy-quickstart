#!/bin/bash

gcloud --project=${PROJECT_ID} container clusters get-credentials \
${CLUSTER_NAME} --zone ${CLUSTER_LOCATION}

cat <<EOF >>apigee-ns.yaml 
apiVersion: v1
kind: Namespace
metadata:
  name: apigee
 
EOF

kubectl --context=${CLUSTER_CTX} apply -f apigee-ns.yaml 

kubectl --context=${CLUSTER_CTX} label namespace apigee istio-injection- istio.io/rev=asm-managed --overwrite

rm apigee-ns.yaml
