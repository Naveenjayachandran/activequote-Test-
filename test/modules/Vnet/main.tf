resource "azurerm_virtual_network" "main" {
  name                = "vnet-main"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "AzureFirewallSubnet"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "ApplicationGatewaySubnet"
    address_prefix = "10.0.2.0/24"
  }

  subnet {
    name           = "VMSubnet"
    address_prefix = "10.0.3.0/24"
  }

  subnet {
    name           = "SQLManagedInstanceSubnet"
    address_prefix = "10.0.4.0/24"
  }

  subnet {
    name           = "BastionSubnet"
    address_prefix = "10.0.5.0/27"
  }

  subnet {
    name           = "GatewaySubnet"
    address_prefix = "10.0.6.0/27"
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-main"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-All"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_virtual_network.main.subnet[2].id
  network_security_group_id  = azurerm_network_security_group.nsg.id
}

output "vnet_name" {
  value = azurerm_virtual_network.main.name
}
