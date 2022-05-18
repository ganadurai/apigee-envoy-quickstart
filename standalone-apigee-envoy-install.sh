#!/bin/bash

set -e

echo "Installing apigee standalone envoy PoC setup"

if [ $PLATFORM -ne 'opdk' ]
then
    printf "\n\nstep 1 : service-accounts.sh\n" 
    ./scripts/service-accounts.sh
fi

printf "\n\nstep 2 : download-libraries.sh\n"
./scripts/download-libraries.sh

printf "\n\nstep 3 : setup-libraries.sh\n"
./scripts/setup-libraries.sh

printf "\n\nstep 4 : setup-apigee.sh\n"
./scripts/setup-apigee.sh

printf "\n\nstep 5 : setup-standalone-envoy.sh\n"
./scripts/setup-standalone-envoy.sh

printf "\n\nstep 6 : test-standalone-apigee-envoy-filter.sh\n"
./scripts/test-standalone-apigee-envoy-filter.sh
