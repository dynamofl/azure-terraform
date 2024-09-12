# aks.tf
# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

data "azurerm_container_registry" "container_registry" {
  name                = var.acr_name
  resource_group_name = var.acr_resource_group_name
}

# Azure Kubernetes Service (AKS) Cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix
  sku_tier            = "Standard"
  kubernetes_version  = "1.30.0"

  default_node_pool {
    name                         = "agentpool"
    vm_size                      = var.agent_vm_size
    os_disk_size_gb              = var.os_disk_size_gb
    type                         = "VirtualMachineScaleSets"
    os_disk_type                 = "Ephemeral"
    vnet_subnet_id               = azurerm_subnet.aks_subnet.id
    zones                        = ["1", "2", "3"]
    auto_scaling_enabled         = true
    min_count                    = var.min_count
    max_count                    = var.max_count
    node_public_ip_enabled       = false
    os_sku                       = "Ubuntu"
    only_critical_addons_enabled = true
    temporary_name_for_rotation  = "pooltemp"

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

  service_mesh_profile {
    mode                             = "Istio"
    internal_ingress_gateway_enabled = false
    external_ingress_gateway_enabled = true
    revisions = [
      "asm-1-21"
    ]
  }

  workload_autoscaler_profile {
    keda_enabled = true
  }

  network_profile {
    network_plugin = "azure"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "userpool" {
  name                   = "userpool"
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.main.id
  vm_size                = "Standard_D16ds_v5"
  os_disk_size_gb        = 128
  vnet_subnet_id         = azurerm_subnet.aks_subnet.id
  max_pods               = 110
  zones                  = ["1", "2", "3"]
  auto_scaling_enabled   = true
  min_count              = 0
  max_count              = 20
  node_public_ip_enabled = false
}


resource "azurerm_kubernetes_cluster_node_pool" "gpunp48a10" {
  name                   = "gpunp48a10"
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.main.id
  vm_size                = "Standard_NV36ads_A10_v5"
  os_disk_size_gb        = 128
  os_disk_type           = "Ephemeral"
  vnet_subnet_id         = azurerm_subnet.aks_subnet.id
  max_pods               = 30
  zones                  = ["1", "2", "3"]
  auto_scaling_enabled   = true
  min_count              = 0
  max_count              = 8
  node_public_ip_enabled = false
  node_taints            = ["nvidia.com/gpu=true:NoSchedule", "gpu-type=a10g:NoSchedule"]
}

resource "azurerm_kubernetes_cluster_node_pool" "gpu1a100" {
  name                   = "gpu1a100"
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.main.id
  vm_size                = "Standard_NC24ads_A100_v4"
  os_disk_size_gb        = 128
  os_disk_type           = "Ephemeral"
  vnet_subnet_id         = azurerm_subnet.aks_subnet.id
  max_pods               = 30
  zones                  = ["1", "2", "3"]
  auto_scaling_enabled   = true
  min_count              = 0
  max_count              = 1
  node_public_ip_enabled = false
  node_taints            = ["nvidia.com/gpu=true:NoSchedule", "gpu-type=a100:NoSchedule"]
}

resource "azurerm_kubernetes_cluster_node_pool" "gpu2a100" {
  name                   = "gpu2a100"
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.main.id
  vm_size                = "Standard_NC48ads_A100_v4"
  os_disk_size_gb        = 128
  os_disk_type           = "Ephemeral"
  vnet_subnet_id         = azurerm_subnet.aks_subnet.id
  max_pods               = 30
  zones                  = ["1", "2", "3"]
  auto_scaling_enabled   = true
  min_count              = 0
  max_count              = 1
  node_public_ip_enabled = false
  node_taints            = ["nvidia.com/gpu=true:NoSchedule", "gpu-type=a100:NoSchedule"]
}


resource "azurerm_kubernetes_cluster_node_pool" "gpu4a100" {
  name                   = "gpu4a100"
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.main.id
  vm_size                = "Standard_NC96ads_A100_v4"
  os_disk_size_gb        = 128
  os_disk_type           = "Ephemeral"
  vnet_subnet_id         = azurerm_subnet.aks_subnet.id
  max_pods               = 30
  zones                  = ["1", "2", "3"]
  auto_scaling_enabled   = true
  min_count              = 0
  max_count              = 1
  node_public_ip_enabled = false
  node_taints            = ["nvidia.com/gpu=true:NoSchedule", "gpu-type=a100:NoSchedule"]
}
