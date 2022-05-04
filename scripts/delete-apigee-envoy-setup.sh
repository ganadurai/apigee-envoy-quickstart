#!/bin/bash

echo "Deleting the namespace - "$NAMESPACE
kubectl --context=${CLUSTER_CTX} delete namespace $NAMESPACE

echo "Deleting the developer app"
curl -H "Authorization: Bearer ${TOKEN}" -X DELETE "https://apigee.googleapis.com/v1/organizations/${ORG}/developers/test-envoy@google.com/apps/envoy-adapter-app-2"

echo "Deleting the developer"
curl -H "Authorization: Bearer ${TOKEN}" -X DELETE "https://apigee.googleapis.com/v1/organizations/${ORG}/developers/test-envoy@google.com"

echo "Deleting the product"
curl -H "Authorization: Bearer ${TOKEN}" -X DELETE "https://apigee.googleapis.com/v1/organizations/${ORG}/apiproducts/envoy-adapter-product-2"

echo "Deleting the service account role binding"
gcloud projects remove-iam-policy-binding $APIGEE_PROJECT_ID \
--member="serviceAccount:$ENVOY_AX_SA@$APIGEE_PROJECT_ID.iam.gserviceaccount.com" \
--role="roles/apigee.analyticsAgent"

echo "Deleting the service account"
gcloud iam service-accounts delete $ENVOY_AX_SA@$APIGEE_PROJECT_ID.iam.gserviceaccount.com \
--project=$APIGEE_PROJECT_ID --quiet

echo "Deleting the directory"
rm -R $CLI_HOME
rm -R $REMOTE_SERVICE_HOME
rm $ENVOY_HOME/*.tar.gz
rm $AX_SERVICE_ACCOUNT

