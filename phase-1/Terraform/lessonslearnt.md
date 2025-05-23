1. multiple network security rules to be creation

__How:__ In variables.tf add the following

            variable network_security_rules {
                description = "metwork security rules to be applied"
                type = map(object( {
                    priority = number
                    access = string
                    protocol = string
                    source_port_range = string
                    destination_port_range = string
                    source_address_prefix = string
                    destination_address_prefix = string
                  }
                  )
                  )
                  default {}
                }

    In network module main.tf file add the following

            resource azurerm_network_security_rules" "nsg_rules" {
              for_each = var.network_security_rules
              name = each.key
              priority= each.value.priority
              access = each.value.access
              .
              .
              network_security_group_name = azurerm_network_security_group.nsg.name
            }

    In root module add the folowing

          module "network-module" {
            source = ./network-module
            network_security_rules= {
            AllowAny22SSH ={
              priority = 101
              access = "Allow"
              protocol = "Tcp"
              .
              .
              destination_address_prefix = "*"
          }
2. Multiple public IP's to create

  resource "azurerm_public_ip" "public-ips" {
    count = 3
    name = public-ip-$(count.index + 1 )
    location =
    resource_group_name = 
    allocation_method = "Static"
  }
  
5. Multiple NIC's to create and to attach the public IPs

    resource "azurerm_network_interface_card" "nic" {
      count = 3
      name = nic-${count.index + 1}
      ipconfiguration{
        public_ip_address_id = azurerm_public_ip.public_ips[count.index].id
   }

6. If a resourcce already exists on azure portal, terraform fails. Solve?

__How:__ import the resource to terraform statefile

import {
  to = azurerm_virtual_network.vnet01
  id = "/subscriptions/....
}

resource "azurerm_virtual_network" "vnet" {
  name = vnet01
  location =
  resource_group_name =
  address_space = ["10.0.0.0/16"]
}

7. How to create a module for network?

__How__ 

- Create a directory for module, network-module
- Inside directory create variables.tf, output.tf and main.tf
- main.tf will have terraform code for network resources.
- variable.tf will have variable description and types.
- output.tf will have output ids
- Inside the root module there will be main.tf which has terraform provider for azure. Therewe will call this module as following

              module network-module {
              source = ./network-module
               name = var.vnet_name
                      .
                      .
                  }

8. state blob is already locked

Error: Error acquiring the state lock
│
│ Error message: state blob is already locked
│ Lock Info:

__How__ 

            az storage blob lease break --account-name storage-account-name --blob-name blob-name --container-name container-name

9. Create multiple VM's using VM module.

locals {
vm_configs = {
vm1 = {
            virtual_machine_name = "master-node"
            nic_id  = azurerm_network_interface.nics[0].id
            vm_size = "Standard_D4s_v3"
            storage_account_type = "Premium_LRS"
       }
vm2 = {
            virtual_machine_name = "worker-node"
            nic_id  = azurerm_network_interface.nics[1].id
            vm_size = "Standard_D4s_v3"
            storage_account_type = "Premium_LRS"
      }

module virtualmachine-module {
     source = ./virtualmachine-module
     for_each = locals.vm_configs
     
     size = each.value.vm_size
     name = each.value.virtual_machine_name
     resource_group_name = data.azurerm_resource_group.devopsproject02-RG.name
     location            = data.azurerm_resource_group.devopsproject02-RG.location
     nic_id              = each.value.nic_id
     admin_username      = "azureuser"
     storage_account_type = each.value.storage_account_type
     output "vm_private_keys" {
  value = {
    for vm_key, vm in module.virtualmachine-module : vm_key => vm.tls_private_key_pem
  }
  sensitive = true
  }
