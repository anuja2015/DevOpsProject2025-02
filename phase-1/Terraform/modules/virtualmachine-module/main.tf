resource "tls_private_key" "azureuser_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "vm" {
    name = var.virtual_machine_name
    location = var.location
    resource_group_name = var.resource_group_name
    network_interface_ids = [var.nic_id]
    size = var.vm_size
    os_disk {
      name = "${var.virtual_machine_name}-osdisk"
      caching = "ReadWrite"
      storage_account_type = var.storage_account_type      
    }
    disable_password_authentication = true
    source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy" # Or '0001-com-ubuntu-server-jammy' for Ubuntu 22.04
    sku       = "22_04-lts"          # Or '22_04-lts-gen2' for Ubuntu 22.04
    version   = "latest"  
    }
    admin_username = var.admin_username
    admin_ssh_key {
        username = var.admin_username
        public_key = tls_private_key.azureuser_ssh.public_key_openssh
    }
    depends_on = [ tls_private_key.azureuser_ssh]

}