
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "vnet_name" {
  type        = string
  description = "The name of the virtual network"
  default     = "default-vnet"
}

variable "address_space" {
  type        = list(string)
  description = "Address space for the VNet"
  default     = ["20.0.0.0/8"]
}

variable "aks_subnet_name" {
  type        = string
  description = "The name of the subnet"
  default     = "aks-subnet"
}

variable "aks_subnet_prefixes" {
  type        = list(string)
  description = "Address prefixes for the subnet"
  default     = ["20.0.0.0/16"]
}

variable "rds_subnet_name" {
  type        = string
  description = "The name of the subnet"
  default     = "rds-subnet"
}

variable "rds_subnet_prefixes" {
  type        = list(string)
  description = "Address prefixes for the subnet"
  default     = ["20.1.0.0/16"]
}

variable "cluster_name" {
  type        = string
  description = "The name of the AKS cluster"
}

variable "location" {
  type        = string
  description = "Azure region for all resources"
  default     = "East US"
}

variable "dns_prefix" {
  type        = string
  description = "DNS prefix for AKS"
}

variable "agent_vm_size" {
  type        = string
  description = "VM size for AKS nodes"
  default     = "Standard_DS2_v2"
}

variable "os_disk_size_gb" {
  type        = number
  description = "Disk size in GB for AKS nodes"
  default     = 128
}

variable "min_count" {
  description = "Minimum number of nodes for autoscaling"
  type        = number
}

variable "max_count" {
  description = "Maximum number of nodes for autoscaling"
  type        = number
}

variable "private_dns_zone_name" {
  description = "The name of the private DNS zone"
  type        = string
  default     = "dynamoai.postgres.database.azure.com"
}

variable "dns_zone_virtual_network_link_name" {
  description = "The name of the private DNS zone virtual network link"
  type        = string
  default     = "dynamoaiprivatelink"
}

variable "postgresql_server_name" {
  description = "Name of the PostgreSQL server"
  type        = string
}

variable "postgresql_version" {
  description = "Version of PostgreSQL"
  default     = "11"
}

variable "administrator_login" {
  description = "Administrator login for PostgreSQL server"
  type        = string
}

variable "administrator_login_password" {
  description = "Administrator login password for PostgreSQL server"
  type        = string
}

variable "sku_name" {
  description = "VM size for the PostgreSQL server"
  default     = "GP_Standard_D4s_v3"
}

variable "storage_size_mb" {
  description = "Storage size in MB for PostgreSQL"
  type        = number
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}

variable "container_name" {
  description = "The name of the storage container"
}

variable "storage_account_sku" {
  description = "The SKU of the storage account"
  type        = string
  default     = "ZRS"
}

variable "storage_account_tier" {
  description = "The access tier of the storage account"
  type        = string
  default     = "Hot"
}

variable "user_assigned_identity_name" {
  description = "The name of the user-assigned managed identity"
}