terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.26.0"
    }
  }

  backend "azurerm" {
    container_name       = "devopsproject02-tfstate"
    key                  = "devopsproject02workload"
    resource_group_name  = "devopsproject02-tfstate-RG"
    storage_account_name = "devopsproject02tfstorage"
  }
}

provider "azurerm" {
  features {
    
  }
  
}

data "azurerm_resource_group" "devopsproject02-RG" {
  name = "devopsproject02-RG"
}

output "id" {
  value = data.azurerm_resource_group.devopsproject02-RG.id
}

module "network-module" {
    source = "./modules/network-module"
    resource_group_name = data.azurerm_resource_group.devopsproject02-RG.name
    location = data.azurerm_resource_group.devopsproject02-RG.location
    virtual_network_name = "devopsproject02-vnet"
    vnet_address_space    = ["172.0.0.0/16"]
    subnet_name           = "project02-subnet01"
    subnet_address_prefix = ["172.0.1.0/24"]
    network_security_group_name = "project02-nsg"
    nsg_security_rules = {
      AllowSSHOnport22 = {
        direction= "Inbound"
        priority="101"
        access="Allow"
        protocol="Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    AllowAnyCustom80Inbound = {
        direction= "Inbound"
        priority="300"
        access="Allow"
        protocol="Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    AllowAnyCustom8080Inbound = {
        direction= "Inbound"
        priority="301"
        access="Allow"
        protocol="Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    AllowCustom30000-32767Inbound = {
        direction= "Inbound"
        priority="110"
        access="Allow"
        protocol="Tcp"
        source_port_range          = "*"
        destination_port_range     = "30000-32767"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    AllowCustom443Inbound = {
        direction= "Inbound"
        priority="311"
        access="Allow"
        protocol="Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    AllowCustom6443Inbound = {
        direction= "Inbound"
        priority="302"
        access="Allow"
        protocol="Tcp"
        source_port_range          = "*"
        destination_port_range     = "6443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    AllowCustom465Inbound = {
        direction= "Inbound"
        priority="111"
        access="Allow"
        protocol="Tcp"
        source_port_range          = "*"
        destination_port_range     = "465"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    AllowCustom3000-10000Inbound = {
        direction= "Inbound"
        priority="321"
        access="Allow"
        protocol="Tcp"
        source_port_range          = "*"
        destination_port_range     = "3000-10000"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    }
}
resource "azurerm_public_ip" "public_ips" {
  count               = 3
  name                = "public-ip-${count.index + 1}"
  location            = data.azurerm_resource_group.devopsproject02-RG.location
  resource_group_name = data.azurerm_resource_group.devopsproject02-RG.name
  allocation_method   = "Static"
  sku                 = "Basic"
  lifecycle {
      create_before_destroy = true
    }
}
resource "azurerm_network_interface" "nics" {
  count               = 3
  name                = "nic-${count.index + 1}"
  location            = data.azurerm_resource_group.devopsproject02-RG.location
  resource_group_name = data.azurerm_resource_group.devopsproject02-RG.name

  ip_configuration {
    name                          = "ipconfig-${count.index + 1}"
    subnet_id                     = module.network-module.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ips[count.index].id
  }
}


##### Create Virtual machines for Kubernetes cluster #####

locals {
  vm_configs = {
    vm1 = {
      virtual_machine_name = "master-node"
      nic_id  = azurerm_network_interface.nics[0].id
      vm_size = "Standard_D4s_v3"
      storage_account_type = "Premium_LRS"
    }
    vm2 = {
      virtual_machine_name = "worker-node01"
      nic_id  = azurerm_network_interface.nics[1].id
      vm_size = "Standard_A4_v2"
      storage_account_type = "Standard_LRS"
    }
    vm3 = {
      virtual_machine_name = "worker-node02"
      nic_id  = azurerm_network_interface.nics[2].id
      vm_size = "Standard_A4_v2"
      storage_account_type = "Standard_LRS"
    }
}
}

module "virtualmachine-module" {
  source = "./modules/virtualmachine-module"
  for_each = local.vm_configs

  virtual_machine_name = each.value.virtual_machine_name
  vm_size = each.value.vm_size
  resource_group_name = data.azurerm_resource_group.devopsproject02-RG.name
  location            = data.azurerm_resource_group.devopsproject02-RG.location
  nic_id              = each.value.nic_id
  admin_username      = "azureuser"
  storage_account_type = each.value.storage_account_type
}
output "vm_private_keys" {
  value = {
    for vm_key, vm in module.virtualmachine-module : vm_key => vm.tls_private_key_pem
  }
  sensitive = true
  depends_on = [
    module.network-module,
    azurerm_public_ip.public_ips,
    azurerm_network_interface.nics
  ]
}



