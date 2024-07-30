# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}"
  location = var.location
}

# Azure Kubernetes Service (AKS) Cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix
  sku_tier            = "Standard"

  default_node_pool {
    name                = "agentpool"
    vm_size             = var.agent_vm_size
    os_disk_size_gb     = var.os_disk_size_gb
    os_disk_type        = "Ephemeral"
    vnet_subnet_id      = azurerm_subnet.aks_subnet.id
    zones               = ["1", "2", "3"]
    enable_auto_scaling = true
    min_count           = var.min_count
    max_count           = var.max_count
    enable_node_public_ip = false
    type                = "VirtualMachineScaleSets"
    
    upgrade_settings {
      max_surge                     = "10%"
      drain_timeout_in_minutes      = 0
      node_soak_duration_in_minutes = 0
    }
  }

  identity {
    type = "SystemAssigned"
  }
    # Enable OIDC issuer
  oidc_issuer_enabled = true

  # Enable workload identity
  workload_identity_enabled = true
}

resource "azurerm_kubernetes_cluster_node_pool" "userpool" {
  name                  = "userpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_D8ds_v5"
  os_disk_size_gb       = 128
  vnet_subnet_id        = azurerm_subnet.aks_subnet.id
  max_pods              = 110
  zones                 = ["1", "2", "3"]
  enable_auto_scaling   = true
  min_count             = 0
  max_count             = 20
  enable_node_public_ip = false

}


resource "azurerm_kubernetes_cluster_node_pool" "gpu1a10" {
  name                  = "gpunp48"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_NV36ads_A10_v5"
  os_disk_size_gb       = 128
  os_disk_type          = "Ephemeral"
  vnet_subnet_id        = azurerm_subnet.aks_subnet.id
  max_pods              = 30
  zones                 = ["1", "2", "3"]
  enable_auto_scaling   = true
  min_count             = 0
  max_count             = 8
  enable_node_public_ip = false
  node_taints           = ["nvidia.com/gpu=true:NoSchedule", "gpu-type=a10g:NoSchedule"]
}

resource "azurerm_kubernetes_cluster_node_pool" "gpu2a10" {
  name                  = "gpunp48"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_NV72ads_A10_v5"
  os_disk_size_gb       = 128
  os_disk_type          = "Ephemeral"
  vnet_subnet_id        = azurerm_subnet.aks_subnet.id
  max_pods              = 30
  zones                 = ["1", "2", "3"]
  enable_auto_scaling   = true
  min_count             = 0
  max_count             = 4
  enable_node_public_ip = false
  node_taints           = ["nvidia.com/gpu=true:NoSchedule", "gpu-type=a10g:NoSchedule"]
}

resource "azurerm_kubernetes_cluster_node_pool" "gpu1a100" {
  name                  = "gpu1a100"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_NC24ads_A100_v4"
  os_disk_size_gb       = 128
  os_disk_type          = "Ephemeral"
  vnet_subnet_id        = azurerm_subnet.aks_subnet.id
  max_pods              = 30
  zones                 = ["1", "2", "3"]
  enable_auto_scaling   = true
  min_count             = 0
  max_count             = 1
  enable_node_public_ip = false
  node_taints           = ["nvidia.com/gpu=true:NoSchedule", "gpu-type=a100:NoSchedule"]
}

resource "azurerm_kubernetes_cluster_node_pool" "gpu2a100" {
  name                  = "gpu2a100"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_NC48ads_A100_v4"
  os_disk_size_gb       = 128
  os_disk_type          = "Ephemeral"
  vnet_subnet_id        = azurerm_subnet.aks_subnet.id
  max_pods              = 30
  zones                 = ["1", "2", "3"]
  enable_auto_scaling   = true
  min_count             = 0
  max_count             = 1
  enable_node_public_ip = false
  node_taints           = ["nvidia.com/gpu=true:NoSchedule", "gpu-type=a100:NoSchedule"]
}


resource "azurerm_kubernetes_cluster_node_pool" "gpu4a100" {
  name                  = "gpu4a100"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_NC96ads_A100_v4"
  os_disk_size_gb       = 128
  os_disk_type          = "Ephemeral"
  vnet_subnet_id        = azurerm_subnet.aks_subnet.id
  max_pods              = 30
  zones                 = ["1", "2", "3"]
  enable_auto_scaling   = true
  min_count             = 0
  max_count             = 1
  enable_node_public_ip = false
  node_taints           = ["nvidia.com/gpu=true:NoSchedule", "gpu-type=a100:NoSchedule"]
}
