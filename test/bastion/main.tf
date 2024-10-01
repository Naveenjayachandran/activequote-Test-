resource "azurerm_bastion_host" "main" {
  name                = "bastion-host"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                 = "bastion-ip-configuration"
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}

resource "azurerm_public_ip" "bastion" {
  name                = "bastion-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  allocation_method   = "Static"
}

output "bastion_ip" {
  value = azurerm_public_ip.bastion.ip_address
}
