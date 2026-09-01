resource "azurerm_linux_virtual_machine" "vm" {
  for_each = local.vm_names

  name                = each.key
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  size = "Standard_D2ns_v6"

  admin_username = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.vm[each.key].id
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = {
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-main"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_public_ip" "vm" {
  for_each = local.vm_names

  name                = "${each.key}-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  allocation_method = "Static"
  sku               = "Standard"
}


resource "azurerm_network_interface" "vm" {
  for_each = local.vm_names

  name                = "${each.key}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm.id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = azurerm_public_ip.vm[each.key].id
  }
}

resource "azurerm_resource_group" "main" {
  name     = "rg-terraform-vms"
  location = "UK South"

  tags = {
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}
