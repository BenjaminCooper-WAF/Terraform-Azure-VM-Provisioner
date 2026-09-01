output "vm_private_ips" {
  value = {
    for name, nic in azurerm_network_interface.vm :
    name => nic.private_ip_address
  }
}

output "vm_public_ips" {
  value = {
    for name, ip in azurerm_public_ip.vm :
    name => ip.ip_address
  }
}
