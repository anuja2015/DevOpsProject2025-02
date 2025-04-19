variable "resource_group_name" {
  description = "The name of the resource group"
  type = string
}

variable "location" {
    description = "The location where resources are created"
    type = string
  
}

variable "virtual_network_name" {
    description = "The name of the virtual network"
    type = string
  
}

variable "subnet_name" {
    description = "The name of  the subnet"
    type = string
  
}

variable "vnet_address_space" {
    description = "The cidr for network ip addresses availble in the vnet"
    type = list(string)
  
}

variable "subnet_address_prefix" {
  description = "The range of ipaddresses in the subnet"
  type = list(string)
}

variable "network_security_group_name"{
    description = "The name for nsg"
    type = string
}

variable "nsg_security_rules" {
  description = "Map of security rules to attach to the NSG"
  type = map(object({
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = {}
}