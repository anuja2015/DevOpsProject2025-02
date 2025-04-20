variable "virtual_machine_name" {
   description = "The virtual machine name"
   type = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type = string
}
variable "location" {
  description = "The location of the virtual machine"
  type = string
}

variable "admin_username" {
    description = "The admin user for the VM"
    type = string
  
}

variable "vm_size" {
    description = "The size of the VM"
    type = string
  
}


variable "storage_account_type" {
  description = "Type of storage account"
  type = string
  
}
variable "nic_id" {
    description = "network interface card"
    type = string
}
