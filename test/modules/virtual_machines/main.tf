resource "azurerm_linux_virtual_machine" "main" {
  count               = 2
  name                = "vm-${count.index + 1}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "your_password_here"
  network_interface_ids = [
    azurerm_network_interface.vm_nic[count.index].id,
  ]
  os_disk {
    caching              = "ReadWrite"
    create_option        = "FromImage"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "vm_nic" {
  count               = 2
  name                = "nic-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig-${count.index + 1}"
    subnet_id                     = azurerm_virtual_network.main.subnet[2].id
    private_ip_address_allocation = "Dynamic"
  }
}

output "vm_names" {
  value = [for vm in azurerm_linux_virtual_machine.main : vm.name]
}
