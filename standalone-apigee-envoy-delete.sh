#!/bin/bash

set -e

echo "Removing apigee envoy PoC setup"

printf "\n\nstep 1 : validate.sh\n" 

./scripts/validate.sh

./scripts/delete-apigee-envoy-setup.sh