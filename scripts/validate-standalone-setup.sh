#!/bin/bash

set -e

if [[ -z $MGMT_HOST ]]; then
    echo "Environment variable OPDK MGMT_HOST is not set, please checkout README.md"
    exit 1
fi

if [[ -z $USER ]]; then
    echo "Environment variable OPDK user credential is not set, please checkout README.md"
    exit 1
fi

if [[ -z $PASSWORD ]]; then
    echo "Environment variable OPDK password credential is not set, please checkout README.md"
    exit 1
fi