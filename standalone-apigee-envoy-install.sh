#!/bin/bash

set -e

echo "Installing apigee standalone envoy PoC setup"

printf "\n\nstep 1 : download-libraries.sh\n"
./scripts/download-libraries.sh

printf "\n\nstep 2 : setup-libraries.sh\n"
./scripts/setup-libraries.sh

printf "\n\nstep 3 : setup-apigee.sh\n"
./scripts/setup-apigee.sh

printf "\n\nstep 4 : setup-standalone-envoy.sh\n"
./scripts/setup-standalone-envoy.sh

printf "\n\nstep 5 : test-standalone-apigee-envoy-filter.sh\n"
./scripts/test-standalone-apigee-envoy-filter.sh
