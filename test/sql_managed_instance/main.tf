resource "azurerm_sql_managed_instance" "main" {
  name                          = "sql-managed-instance"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  administrator_login           = "sqladmin"
  administrator_login_password   = "your_password_here"
  subnet_id                     = azurerm_virtual_network.main.subnet[3].id
  storage_size_in_gb           = 32
  v_core                        = 4
  version                       = "Gen5"
}

output "sql_managed_instance_name" {
  value = azurerm_sql_managed_instance.main.name
}
