# Apigee Envoy PoC Toolkit

The Apigee Envoy PoC Toolkit PoC generator for [Apigee protected ASM Envoy Proxies within Kubernetes Engine](https://cloud.google.com/apigee/docs/api-platform/envoy-adapter/v2.0.x/example-hybrid).

## Quickstart 

1. **[Create a Google Cloud Project](https://cloud.google.com/resource-manager/docs/creating-managing-projects)** and connect it to an existing Billing account.

2. Setup a GKE cluster. Have the cluster enabled with Anthos Service Mesh. Checkout this **[gke poc toolkit](https://github.com/GoogleCloudPlatform/gke-poc-toolkit)** to standup a GKE cluster via automation with ASM enabled.

3. Set your GCP Project ID, Apigee platform environment variables. **This toolkit has to be executed in a Linux environment.** 
    ```bash
    export PROJECT_ID=<your-project-id>
    export CLUSTER_NAME=<gke-cluster-name>
    export CLUSTER_LOCATION=<gke-cluster-region>
    export APIGEE_PROJECT_ID=<apigee-project-id>
    export ORG=<apigee-org>
    export ENV=<apigee-env>
    export RUNTIME=<env-group-virtualhost-prefixed with http/https>
    export APIGEE_REMOTE_SRVC_CLI_VERSION=<version for Apigee Remote Service cli for Envoy>
    export APIGEE_REMOTE_SRVC_ENVOY_VERSION=<version for Apigee Remote Service for Envoy>
    ```

4. **Set up local authentication to your project.**
    ```bash
    gcloud config set project $PROJECT_ID
    gcloud auth application-default login --no-launch-browser

    export TOKEN=$(gcloud auth print-access-token);echo $TOKEN
    ```

5. **Download the Apigee Envoy PoC Toolkit binary.** 
    ```bash
    mkdir apigee-envoy && cd "$_"
    export ENVOY_HOME=$(pwd)
    wget -O apigee-envoy-quickstart-main.zip https://github.com/ganadurai/apigee-envoy-quickstart/archive/refs/heads/main.zip
    unzip apigee-envoy-quickstart-main.zip
    ```

6. **Install PoC:**
    ```bash 
    cd apigee-envoy-quickstart-main
    ./aekitctl.sh install
    ```

7. **Run to run the Toolkit.**
    ```bash 
    ./aekitctl create
    ```

