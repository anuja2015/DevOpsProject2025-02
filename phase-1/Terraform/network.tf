terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.26.0"
    }
  }
}

provider "azurerm" {
  features {
    
  }
  
}

data "azurerm_resource_group" "devopsproject02-RG" {
  name = "devopsproject-02"
}

output "id" {
  value = data.azurerm_resource_group.devopsproject02-RG.id
}

resource "azurerm_virtual_network" "project02-vnet" {
    name = "devopsproject02-vnet"
    location = "eastus"
    resource_group_name = data.azurerm_resource_group.devopsproject02-RG.name
    address_space = ["172.0.0.0/16"]

}

resource "azurerm_subnet" "project02-subnet01" {
    name = "project02-subnet01"
    resource_group_name = data.azurerm_resource_group.devopsproject02-RG.name
    virtual_network_name = azurerm_virtual_network.project02-vnet.name
    address_prefixes = ["172.0.1.0/24"]
  
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
    subnet_id                     = azurerm_subnet.project02-subnet01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ips[count.index].id
  }
}

resource "azurerm_network_security_group" "project02-nsg" {
    name = "project02-nsg"
    location = data.azurerm_resource_group.devopsproject02-RG.location
    resource_group_name = data.azurerm_resource_group.devopsproject02-RG.name
    security_rule {
        name = "AllowSSHOnport22"
        direction= "Inbound"
        priority="101"
        access="Allow"
        protocol="Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name = "AllowAnyCustom80Inbound"
        direction= "Inbound"
        priority="300"
        access="Allow"
        protocol="Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name = "AllowAnyCustom8080Inbound"
        direction= "Inbound"
        priority="301"
        access="Allow"
        protocol="Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name = "AllowCustom30000-32767Inbound"
        direction= "Inbound"
        priority="110"
        access="Allow"
        protocol="Tcp"
        source_port_range          = "*"
        destination_port_range     = "30000-32767"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name = "AllowCustom443Inbound"
        direction= "Inbound"
        priority="311"
        access="Allow"
        protocol="Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name = "AllowCustom6443Inbound"
        direction= "Inbound"
        priority="302"
        access="Allow"
        protocol="Tcp"
        source_port_range          = "*"
        destination_port_range     = "6443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name = "AllowCustom465Inbound"
        direction= "Inbound"
        priority="111"
        access="Allow"
        protocol="Tcp"
        source_port_range          = "*"
        destination_port_range     = "465"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    
        
        
  
}

resource "azurerm_subnet_network_security_group_association" "nsg-to-subnet" {
  subnet_id                 = azurerm_subnet.project02-subnet01.id
  network_security_group_id = azurerm_network_security_group.project02-nsg.id
}