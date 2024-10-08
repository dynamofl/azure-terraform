# rds.tf

resource "azurerm_private_dns_zone" "postgresql_dns_zone" {
  name                = var.private_dns_zone_name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgresql_link" {
  name                  = var.dns_zone_virtual_network_link_name
  private_dns_zone_name = azurerm_private_dns_zone.postgresql_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = azurerm_resource_group.rg.name
}

resource "azurerm_postgresql_flexible_server" "postgresql" {
  name                          = var.postgresql_server_name
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = var.location
  version                       = var.postgresql_version
  delegated_subnet_id           = azurerm_subnet.rds_subnet.id
  private_dns_zone_id           = azurerm_private_dns_zone.postgresql_dns_zone.id
  public_network_access_enabled = false
  administrator_login           = var.administrator_login
  administrator_password        = var.administrator_login_password
  zone                          = "1"

  storage_mb   = var.storage_size_mb
  storage_tier = "P30"
  sku_name     = var.sku_name
  depends_on   = [azurerm_private_dns_zone_virtual_network_link.postgresql_link]
}

resource "azurerm_postgresql_flexible_server_configuration" "require_secure_transport" {
  name      = var.azurerm_postgresql_require_secure_transport
  server_id = azurerm_postgresql_flexible_server.postgresql.id
  value     = "OFF"

  depends_on = [azurerm_postgresql_flexible_server.postgresql]
}

resource "azurerm_postgresql_flexible_server_database" "dynamofl" {
  name       = var.postgresql_database_dynamofl_name
  server_id  = azurerm_postgresql_flexible_server.postgresql.id
  charset    = "UTF8"
  collation  = "en_US.utf8"
  depends_on = [azurerm_postgresql_flexible_server.postgresql]
}

resource "azurerm_postgresql_flexible_server_database" "keycloak" {
  name       = var.postgresql_database_keycloak_name
  server_id  = azurerm_postgresql_flexible_server.postgresql.id
  charset    = "UTF8"
  collation  = "en_US.utf8"
  depends_on = [azurerm_postgresql_flexible_server.postgresql]
}
