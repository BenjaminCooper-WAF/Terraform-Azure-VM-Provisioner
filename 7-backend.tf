terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "tfstatebenji2026"
    container_name       = "tfstate"
    key                  = "two-vm-linux.tfstate"
  }
}
