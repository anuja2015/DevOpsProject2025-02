output "subnet_id" {
  description = "The ID of the subnet"
  value       = azurerm_subnet.project02-subnet01.id
}


output "network_security_group_ids" {
  value = {
    for name, nsg in azurerm_network_security_group.nsg : name => nsg.id
  }
}

