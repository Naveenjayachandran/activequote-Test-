provider "azurerm" {
  features {}
}

variable "subscription_id" {
  description = "The subscription ID"
  default     = "efbc46f4-744a-467e-a809-13fad2288a3f"
}

variable "tenant_id" {
  description = "The tenant ID"
  default     = "a968f3a4-abcd-456d-a65d-2a123456789e"
}

resource "azurerm_resource_group" "main" {
  name     = "rg-networking"
  location = "UK South"
}

module "vnet" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
}

module "azure_firewall" {
  source              = "./modules/azure_firewall"
  resource_group_name = azurerm_resource_group.main.name
  vnet_name          = module.vnet.vnet_name
}

module "application_gateway" {
  source              = "./modules/application_gateway"
  resource_group_name = azurerm_resource_group.main.name
  vnet_name          = module.vnet.vnet_name
}

module "bastion" {
  source              = "./modules/bastion"
  resource_group_name = azurerm_resource_group.main.name
  vnet_name          = module.vnet.vnet_name
}

module "vnet_gateway" {
  source              = "./modules/vnet_gateway"
  resource_group_name = azurerm_resource_group.main.name
  vnet_name          = module.vnet.vnet_name
}

module "sql_managed_instance" {
  source              = "./modules/sql_managed_instance"
  resource_group_name = azurerm_resource_group.main.name
  vnet_name          = module.vnet.vnet_name
}

module "virtual_machines" {
  source              = "./modules/virtual_machines"
  resource_group_name = azurerm_resource_group.main.name
  vnet_name          = module.vnet.vnet_name
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "vnet_name" {
  value = module.vnet.vnet_name
}
