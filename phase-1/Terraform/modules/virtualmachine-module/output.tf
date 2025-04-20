output "tls_private_key_pem" {
  value     = tls_private_key.azureuser_ssh.private_key_pem
  sensitive = true
}

output "virtual_machine_id" {
  value = azurerm_linux_virtual_machine.vm.id
}
