output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "aks_subnet_id" {
  value = azurerm_subnet.aks_subnet.id
}

output "rds_subnet_id" {
  value = azurerm_subnet.rds_subnet.id
}

output "aks_cluster_id" {
  value = azurerm_kubernetes_cluster.main.id
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.main.name
}

output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "container_name" {
  value = azurerm_storage_container.storage_container.name
}

output "user_assigned_identity_client_id" {
  value = azurerm_user_assigned_identity.workload_identity.client_id
}

output "user_assigned_identity_principal_id" {
  value = azurerm_user_assigned_identity.workload_identity.principal_id
}

output "user_assigned_identity_name" {
  value = azurerm_user_assigned_identity.workload_identity.name
}