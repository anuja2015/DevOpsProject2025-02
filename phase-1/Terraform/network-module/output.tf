output "subnet_id" {
  description = "The ID of the subnet"
  value       = azurerm_subnet.project02-subnet01.id
}

output "nsg_id" {
  description = "The ID of the network security group"
  value       = azurerm_network_security_group.project02-nsg.id
}
