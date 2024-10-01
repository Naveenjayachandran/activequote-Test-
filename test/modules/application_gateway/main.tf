resource "azurerm_application_gateway" "main" {
  name                = "app-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }
  gateway_ip_configuration {
    name      = "gateway-ip-configuration"
    subnet_id = azurerm_virtual_network.main.subnet[1].id
  }
  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.app_gateway.id
  }
  frontend_port {
    name = "frontend-port"
    port = 80
  }
  backend_address_pool {
    name = "backend-pool"
  }
  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
  }
  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "frontend-port"
    protocol                       = "Http"
  }
  request_routing_rule {
    name                       = "rule1"
    rule_type                 = "Basic"
    http_listener_name        = "http-listener"
    backend_address_pool_name = "backend-pool"
    backend_http_settings_name = "http-settings"
  }
}

resource "azurerm_public_ip" "app_gateway" {
  name                = "app-gateway-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  allocation_method   = "Static"
}

output "app_gateway_ip" {
  value = azurerm_public_ip.app_gateway.ip_address
}
