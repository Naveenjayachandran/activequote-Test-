resource "azurerm_firewall" "main" {
  name                = "azure-firewall"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                 = "firewall-ip-configuration"
    subnet_id           = azurerm_virtual_network.main.subnet[0].id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

resource "azurerm_public_ip" "firewall" {
  name                = "firewall-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  allocation_method   = "Static"
}

output "firewall_ip" {
  value = azurerm_public_ip.firewall.ip_address
}
