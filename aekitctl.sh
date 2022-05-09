#!/bin/bash

set -e

usage() {
    echo -e "$*\n usage: $(basename "$0")" \
        "-t <type> -a <action>\n" \
        "example: $(basename "$0") -t istio-apigee-envoy -a install\n" \
        "example: $(basename "$0") -t istio-apigee-envoy -a delete\n" \
        "example: $(basename "$0") -t standalone-apigee-envoy -a install\n" \
        "example: $(basename "$0") -t standalone-apigee-envoy -a delete\n" \
        "Parameters:\n" \
        "-t --type        : Apigee protected Envoy installation type, valida values 'istio-apigee-envoy'. 'standalone-apigee-envoy'\n" \
        "-a --action      : Install or Delete action, valid values 'install', 'delete'\n"
    exit 1
}

usage() {
  echo '';
  echo 'Usage:';
  echo './aekitctl.sh --type=istio-apigee-envoy --action=install';
  echo './aekitctl.sh istio-apigee-envoy delete';
  echo './aekitctl.sh standalone-apigee-envoy install';
  echo './aekitctl.sh standalone-apigee-envoy delete';
  echo '';
}

if [[ -z $1 ]]
then
   usage;
   exit 1;
fi

export CLUSTER_CTX="gke_${PROJECT_ID}_${CLUSTER_LOCATION}_${CLUSTER_NAME}"
export ENVOY_AX_SA="x-apigee-envoy-adapter-2-sa"
export CLI_HOME=$ENVOY_HOME/apigee-remote-service-cli
export REMOTE_SERVICE_HOME=$ENVOY_HOME/apigee-remote-service-envoy
export ENVOY_CONFIGS_HOME=$CLI_HOME/envoy-configs-and-samples
export AX_SERVICE_ACCOUNT=$ENVOY_HOME/$ENVOY_AX_SA.json
export NAMESPACE="apigee"

if [ $1 == 'install' ]
then
    echo "Installing apigee envoy PoC setup"

    printf "\n\nstep 1 : validate.sh\n" 
    mkdir $CLI_HOME
    mkdir $REMOTE_SERVICE_HOME
    ./scripts/validate.sh

    printf "\n\nstep 2 : service-accounts.sh\n" 
    ./scripts/service-accounts.sh

    printf "\n\nstep 3 : prepare-namespace.sh\n"
    ./scripts/prepare-namespace.sh

    printf "\n\nstep 4 : download-libraries.sh\n"
    ./scripts/sedownloadtup-libraries.sh

    printf "\n\nstep 5 : setup-libraries.sh\n"
    ./scripts/setup-libraries.sh

    printf "\n\nstep 6 : setup-istio-envoy.sh\n"
    ./scripts/setup-istio-envoy.sh

    printf "\n\nstep 6 : setup-apigee.sh\n"
    ./scripts/setup-apigee.sh

    printf "\n\nstep 7 : setup-envoy-filters.sh\n"
    ./scripts/setup-envoy-filters.sh

    printf "\n\nstep 8 : test-apigee-envoy-filter.sh\n"
    ./scripts/test-istio-apigee-envoy-filter.sh

elif [ $1 == 'delete' ]
then
    echo "Removing apigee envoy PoC setup"

    printf "\n\nstep 1 : validate.sh\n" 
    
    ./scripts/validate.sh

    ./scripts/delete-apigee-envoy-setup.sh
else
    usage;
    exit 1; 
fi