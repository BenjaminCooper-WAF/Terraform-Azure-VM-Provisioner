resource "azurerm_subnet" "vm" {
  name                 = "subnet-vms"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name

  address_prefixes = [
    "10.10.1.0/24"
  ]
}