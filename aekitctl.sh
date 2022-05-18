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

init() {
    export CLUSTER_CTX="gke_${PROJECT_ID}_${CLUSTER_LOCATION}_${CLUSTER_NAME}"
    export ENVOY_AX_SA="x-apigee-envoy-adapter-2-sa"
    export CLI_HOME=$ENVOY_HOME/apigee-remote-service-cli
    export REMOTE_SERVICE_HOME=$ENVOY_HOME/apigee-remote-service-envoy
    export ENVOY_CONFIGS_HOME=$CLI_HOME/envoy-configs-and-samples
    export AX_SERVICE_ACCOUNT=$ENVOY_HOME/$ENVOY_AX_SA.json
    export NAMESPACE="apigee"
}

createDir() {

    mkdir $CLI_HOME
    mkdir $REMOTE_SERVICE_HOME

}

PARAMETERS=()

if [[ $# -ne 4 && $# -ne 6 ]]
then
   usage;
   exit 1;
fi  

while [[ $# -gt 0 ]]
do
    param="$1"
    case $param in
        -t|--type)
        export INSTALL_TYPE="$2"
        shift
        shift
        ;;
        -a|--action)
        export ACTION="$2"
        shift
        shift
        ;;
        -p|--platform)
        export PLATFORM="$2"
        shift
        shift
        ;;
        *)
        PARAMETERS+=("$1")
        shift
        ;;
    esac
done
 
if [[ -z $INSTALL_TYPE ]]; then
    usage "installation type is a mandatory field"
fi

if [[ -z $ACTION ]]; then
    usage "action is a mandatory field"
fi

init;

if [ $PLATFORM == 'opdk' ]
then
    export TOKEN=$(echo -n "$USER":"$PASSWORD" | base64 | tr -d \\r)
    export TOKEN_TYPE="Basic"
else
    export TOKEN_TYPE="Bearer"
    export MGMT_HOST="https://apigee.googleapis.com"
fi

./scripts/validate.sh

if [ "$PLATFORM" == 'opdk' ]
then
    ./scripts/validate-opdk-setup.sh
else
    ./scripts/validate-new-gen-setup.sh
fi

if [ $INSTALL_TYPE == 'istio-apigee-envoy' -a $ACTION == 'install' ]
then
    createDir;
    echo "Installing istio-apigee-envoy"
    export TEMPLATE="istio-1.12"
    ./istio-apigee-envoy-install.sh
elif [ $INSTALL_TYPE == 'istio-apigee-envoy' -a $ACTION == 'delete' ]
then
    echo "Deleting istio-apigee-envoy"
    ./scripts/delete-apigee-envoy-setup.sh
elif [ $INSTALL_TYPE == 'standalone-apigee-envoy' -a $ACTION == 'install' ]
then
    createDir;
    echo "Installing standalone-apigee-envoy"
    export TEMPLATE="envoy-1.15"
    ./standalone-apigee-envoy-install.sh
elif [ $INSTALL_TYPE == 'standalone-apigee-envoy' -a $ACTION == 'delete' ]
then
    echo "Deleting standalone-apigee-envoy"
    ./scripts/delete-apigee-envoy-setup.sh
else
    usage;
    exit 1; 
fi
