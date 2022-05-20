#!/bin/bash

set -e

echo "Installing apigee istio envoy PoC setup"

printf "\n\nstep 1 : service-accounts.sh\n" 
./scripts/service-accounts.sh

printf "\n\nstep 2 : prepare-namespace.sh\n"
./scripts/prepare-namespace.sh

printf "\n\nstep 3 : download-libraries.sh\n"
./scripts/download-libraries.sh

printf "\n\nstep 4 : setup-libraries.sh\n"
./scripts/setup-libraries.sh

printf "\n\nstep 5 : setup-istio-envoy.sh\n"
./scripts/setup-istio-envoy.sh

printf "\n\nstep 6 : setup-apigee.sh\n"
./scripts/setup-apigee.sh

printf "\n\nstep 7 : setup-envoy-filters.sh\n"
./scripts/setup-envoy-filters.sh

printf "\n\nstep 8 : test-apigee-envoy-filter.sh\n"
./scripts/test-istio-apigee-envoy-filter.sh
