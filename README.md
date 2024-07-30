# azure-terraform

## Overview
This repository contains Terraform configurations for deploying and managing resources on Microsoft Azure for the DynamoAI project. The configurations include setting up a resource group, virtual network, AKS (Azure Kubernetes Service) cluster, PostgreSQL database, and storage accounts.

## Directory Structure
- `dynamoai-azure-terraform/`
  - `tfvars/`
    - `dynamoai-azure-default.tfvars`: Contains default variable values for the Terraform configurations.

## Configuration Details
### Resource Group
- **Name**: `dynamoai-eastus-rg`
- **Location**: `East US`

### Virtual Network
- **Name**: `dynamoai-vnet`
- **Address Space**: `20.0.0.0/8`
- **Subnets**:
  - **AKS Subnet**: `dynamoai-aks-subnet` with prefix `20.0.0.0/16`
  - **RDS Subnet**: `dynamoai-rds-subnet` with prefix `20.1.0.0/16`

### AKS Cluster
- **Cluster Name**: `dynamoai-aks-cluster`
- **DNS Prefix**: `dynamoai-aks`
- **Agent VM Size**: `Standard_D8ds_v5`
- **OS Disk Size**: `128 GB`
- **Node Count**: Min `1`, Max `10`

### PostgreSQL Database
- **Server Name**: `dynamoai-postgresql`
- **Version**: `16`
- **Administrator Login**: `adminuser`
- **Password**: `Dyn@m0AI`
- **SKU Name**: `GP_Standard_D4s_v3`
- **Storage Size**: `131072 MB`
- **Private DNS Zone Name**: `dynamoai.postgres.database.azure.com`
- **DNS Zone Virtual Network Link Name**: `dynamoaiprivatelink`

### Storage Account
- **Name**: `dynamoaistorage`
- **SKU**: `ZRS`
- **Tier**: `Hot`
- **Container Name**: `dynamoaicontainer`

### User Assigned Identity
- **Name**: `dynamoai-identity`

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
export SERVICE_ACCOUNT_NAME="milvus-abs-access-sa"
export SERVICE_ACCOUNT_NAMESPACE="default"

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