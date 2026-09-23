resource "azurerm_network_security_group" "vm" {
  name                = "sec-group-vms"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${var.my_ip}/32"
    destination_address_prefix = "*"
  }

  tags = {
    evironment = "lab"
    ManagedBy  = "Terraform"
  }
}

resource "azurerm_network_interface_security_group_association" "vm" {
  for_each = azurerm_network_interface.vm

  network_interface_id      = each.value.id
  network_security_group_id = azurerm_network_security_group.vm.id
}