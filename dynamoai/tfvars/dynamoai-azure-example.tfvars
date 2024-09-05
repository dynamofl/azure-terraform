resource_group_name = "dynamoai-terraform-test"
location            = "West US 2"
vnet_name           = "dynamoai-vnet"
aks_subnet_name     = "dynamoai-aks-subnet"
rds_subnet_name     = "dynamoai-rds-subnet"
address_space       = ["20.0.0.0/8"]
aks_subnet_prefixes = ["20.0.0.0/16"]
rds_subnet_prefixes = ["20.1.0.0/16"]
cluster_name        = "dynamoai-terraform-test"
dns_prefix          = "dynamoai-aks"
agent_vm_size       = "Standard_D4pds_v5"
os_disk_size_gb     = 128
min_count           = 1
max_count           = 10

private_dns_zone_name                = "dynamoai.postgres.database.azure.com"
dns_zone_virtual_network_link_name   = "dynamoaiprivatelink"
postgresql_server_name               = "dynamoai-postgresql"
postgresql_version                   = "16"
administrator_login                  = "adminuser"
administrator_login_password         = "Dyn@m0AI"
sku_name                             = "GP_Standard_D4s_v3"
storage_size_mb                      = 131072

storage_account_name      = "dynamoaiterraformtest"
storage_account_sku       = "ZRS"
storage_account_tier      = "Hot"

container_name                    = "container-tf"
user_assigned_identity_name       = "azure-terraform-identity"