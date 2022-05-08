#!/bin/bash

set -e

echo "Installing apigee envoy PoC setup"

printf "\n\nstep 1 : validate.sh\n" 
./scripts/validate.sh

printf "\n\nstep 2 : service-accounts.sh\n" 
./scripts/service-accounts.sh

printf "\n\nstep 4 : download-libraries.sh\n"
./scripts/download-libraries.sh

printf "\n\nstep 5 : setup-libraries.sh\n"
./scripts/setup-libraries.sh

printf "\n\nstep 6 : setup-apigee.sh\n"
./scripts/setup-apigee.sh

printf "\n\nstep 7 : setup-standalone-envoy.sh\n"
./scripts/setup-standalone-envoy.sh

printf "\n\nstep 8 : test-standalone-apigee-envoy-filter.sh\n"
./scripts/test-apigee-envoy-filter.sh
