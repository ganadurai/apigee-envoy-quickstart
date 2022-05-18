#!/bin/bash

set -e

echo "Set up Apigee Product, for the endpoint targetted in K8s environment via Envoy proxy"

if [ $INSTALL_TYPE == 'istio-apigee-envoy' ]
then
    curl -H "Authorization: ${TOKEN_TYPE} ${TOKEN}"   -H "Content-Type:application/json"   "${MGMT_HOST}/v1/organizations/${ORG}/apiproducts" -d \
    '{
    "name": "envoy-adapter-product-2",
    "displayName": "envoy-adapter-product-2",
    "approvalType": "auto",
    "attributes": [
        {
        "name": "access",
        "value": "public"
        }
    ],
    "description": "API Product for api proxies in Envoy",
    "environments": [
        "'${ENV}'"
    ],
    "operationGroup": {
        "operationConfigs": [
        {
            "apiSource": "httpbin.apigee.svc.cluster.local",
            "operations": [
            {
                "resource": "/headers"
            }
            ],
            "quota": {}
        },
        {
            "apiSource": "httpbin.org",
            "operations": [
            {
                "resource": "/headers"
            }
            ],
            "quota": {}
        }
        ],
        "operationConfigType": "remoteservice"
    }
    }'
else
    curl -H "Authorization: ${TOKEN_TYPE} ${TOKEN}"   -H "Content-Type:application/json"   "${MGMT_HOST}/v1/organizations/${ORG}/apiproducts" -d \
    '{
    "name" : "envoy-adapter-product-2",
    "displayName" : "envoy-adapter-product-2",
    "approvalType" : "auto",
    "attributes" : [ {
        "name" : "access",
        "value" : "public"
    }, {
        "name" : "apigee-remote-service-targets",
        "value" : "httpbin.org"
    } ],
    "description" : "API Product for api proxies in Envoy",
    "environments": [
        "'${ENV}'"
    ],
    "apiResources" : [ "/headers" ]
    }'
fi


echo "Set up Apigee Developer"

curl -H "Authorization: ${TOKEN_TYPE} ${TOKEN}"   -H "Content-Type:application/json"   "${MGMT_HOST}/v1/organizations/${ORG}/developers" -d \
    '{
    "email": "test-envoy@google.com",
    "firstName": "Test",
    "lastName": "Envoy",
    "userName": "pocenvoystarter"
    }'

echo 'Set up developer app for the Product having the endpoint targetted in K8s environment via Envoy proxy'

curl -H "Authorization: ${TOKEN_TYPE} ${TOKEN}"   -H "Content-Type:application/json"   "${MGMT_HOST}/v1/organizations/${ORG}/developers/test-envoy@google.com/apps" -d \
    '{
    "name":"envoy-adapter-app-2",
    "apiProducts": [
        "envoy-adapter-product-2"
        ]
    }'

