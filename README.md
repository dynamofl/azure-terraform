# Dynamo AI Azure Terraform Module 

## Overview
The `dynamoai` Terraform module creates all necessary resources for a Dynamo AI K8s cluster on Microsoft Azure. The configurations include setting up a resource group, virtual network, AKS (Azure Kubernetes Service) cluster, PostgreSQL database, and storage accounts. 

## Directory Structure
- `dynamoai/`
  - `tfvars/`
    - `dynamoai-azure-default.tfvars`: Contains default variable values for the Terraform configurations.

## Configuration Details
This repository deploys the following resources on Microsoft Azure:
- Resource Group
- Virtual Network with Subnets
- AKS (Azure Kubernetes Service) Cluster
- PostgreSQL Database
- Storage Account with Container
- User Assigned Identity

## Usage
1. Clone the repository:
   ```sh
   git clone <repository-url>
   cd azure-terraform
   ```

2. Initialize Terraform:
   ```sh
   terraform init
   ```

3. Apply the Terraform configurations:
   ```sh
   terraform apply -var-file=tfvars/dynamoai-azure-default.tfvars
   ```

4. Run the following shell commands to configure the federated identity for workload identity:
```sh
# Set environment variables
export RESOURCE_GROUP="<your resource group>"
export AKS_CLUSTER="<your aks cluster name>" 
export SUB_ID="<your Subscription ID>"
export USER_ASSIGNED_IDENTITY_NAME="workload-identity"
export SERVICE_ACCOUNT_NAME="dynamoai-service-account"
export SERVICE_ACCOUNT_NAMESPACE="dynamoai"

# Get the OIDC issuer URL
export SERVICE_ACCOUNT_ISSUER="$(az aks show --resource-group ${RESOURCE_GROUP} --name ${AKS_CLUSTER} --query 'oidcIssuerProfile.issuerUrl' -otsv)"

# Establish federated identity credential between the identity and the service account issuer & subject
az identity federated-credential create \
  --name "kubernetes-federated-credential" \
  --identity-name "${USER_ASSIGNED_IDENTITY_NAME}" \
  --resource-group "${RESOURCE_GROUP}" \
  --issuer "${SERVICE_ACCOUNT_ISSUER}" \
  --subject "system:serviceaccount:${SERVICE_ACCOUNT_NAMESPACE}:${SERVICE_ACCOUNT_NAME}"
```

## Prerequisites
- Terraform installed on your local machine.
- Azure CLI installed and authenticated.

## Contributing
Please submit issues and pull requests for any improvements or bug fixes.

## License
This project is licensed under the Apache License.