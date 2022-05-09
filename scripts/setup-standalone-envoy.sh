#!/bin/bash

set -e

chmod 644 $CLI_HOME/config.yaml

nohup docker run -v $CLI_HOME/config.yaml:/config.yaml \
-p 5000:5000 google/apigee-envoy-adapter:v2.0.5 &

mkdir $ENVOY_CONFIGS_HOME/logs

chmod 777 $ENVOY_CONFIGS_HOME/logs

cd $ENVOY_CONFIGS_HOME
sed -i "s/localhost/127.0.0.1/g" $ENVOY_CONFIGS_HOME/envoy-config.yaml

chmod 644 $ENVOY_CONFIGS_HOME/envoy-config.yaml

nohup docker run --net=host -v $ENVOY_CONFIGS_HOME/logs:/tmp/logs \
-v $ENVOY_CONFIGS_HOME/envoy-config.yaml:/etc/envoy/envoy.yaml \
-p 8080:8080 \
--rm envoyproxy/envoy:v1.21-latest --log-path /tmp/logs/custom.log \
-c /etc/envoy/envoy.yaml --log-level debug &



