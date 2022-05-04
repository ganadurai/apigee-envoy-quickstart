#!/bin/bash

gcloud iam service-accounts create $ENVOY_AX_SA \
--project=$APIGEE_PROJECT_ID

gcloud projects add-iam-policy-binding $APIGEE_PROJECT_ID --member \
"serviceAccount:$ENVOY_AX_SA@$APIGEE_PROJECT_ID.iam.gserviceaccount.com" \--role "roles/apigee.analyticsAgent"

gcloud projects get-iam-policy $APIGEE_PROJECT_ID --flatten="bindings[].members" \
--format='table(bindings.role)' \
--filter="bindings.members:$ENVOY_AX_SA@$APIGEE_PROJECT_ID.iam.gserviceaccount.com" \
| grep "roles/apigee.analyticsAgent"

gcloud iam service-accounts keys create $AX_SERVICE_ACCOUNT \
--project=$APIGEE_PROJECT_ID \
--iam-account=$ENVOY_AX_SA@$APIGEE_PROJECT_ID.iam.gserviceaccount.com

