# network.tf

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.address_space
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.aks_subnet_prefixes
}

resource "azurerm_subnet" "rds_subnet" {
  name                 = var.rds_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.rds_subnet_prefixes
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "gateway_subnet" {
  name                 = var.gateway_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.gateway_subnet_prefixes
}


# Public IP Address
resource "azurerm_public_ip" "network" {
  name                 = var.ingress_application_public_ip_name
  location             = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  allocation_method    = "Static"
  sku                  = "Standard"
}


resource "azurerm_application_gateway" "ingress" {
  name                = var.ingress_application_gateway_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  # verify this identity
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.workload_identity.id
    ]
  }

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  autoscale_configuration {
    min_capacity = 0
    max_capacity = 10
  }

  # verify subnet id
  gateway_ip_configuration {
    name      = var.gateway_ip_configuration_name
    subnet_id = azurerm_subnet.gateway_subnet.id
  }

  frontend_port {
    name = var.frontend_port_name
    port = 80
  }

  # verify public_ip_address_id
  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.network.id
  }

  backend_address_pool {
    name = var.backend_address_pool_name
  }

  backend_http_settings {
    name                  = var.backend_http_settings_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
  }

  http_listener {
    name                           = var.http_listener_name
    frontend_ip_configuration_name = var.frontend_ip_configuration_name
    frontend_port_name             = var.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = var.request_routing_rule_name
    priority                   = 1
    rule_type                  = "Basic"
    http_listener_name         = var.http_listener_name
    backend_address_pool_name  = var.backend_address_pool_name
    backend_http_settings_name = var.backend_http_settings_name
  }
}