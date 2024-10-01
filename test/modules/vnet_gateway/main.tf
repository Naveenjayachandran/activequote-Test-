resource "azurerm_virtual_network_gateway" "main" {
  name                = "vnet-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = "Vpn"
  vpn_type           = "RouteBased"
  sku {
    name     = "VpnGw2"
    tier     = "VpnGw2"
  }
  ip_configuration {
    name                          = "gateway-ip-configuration"
    subnet_id                    = azurerm_virtual_network.main.subnet[5].id
    public_ip_address_id = azurerm_public_ip.gateway.id
  }
}

resource "azurerm_public_ip" "gateway" {
  name                = "gateway-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  allocation_method   = "Static"
}

output "vnet_gateway_ip" {
  value = azurerm_public_ip.gateway.ip_address
}
