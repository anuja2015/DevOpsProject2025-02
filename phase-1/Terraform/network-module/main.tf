
resource "azurerm_virtual_network" "project02-vnet" {
    name = var.virtual_network_name
    location = var.location
    resource_group_name = var.resource_group_name
    address_space = var.vnet_address_space

}

resource "azurerm_subnet" "project02-subnet01" {
    name = var.subnet_name
    resource_group_name = var.resource_group_name
    virtual_network_name = var.virtual_network_name
    address_prefixes = var.subnet_address_prefix
    depends_on = [ azurerm_virtual_network.project02-vnet ]
  
}

resource "azurerm_network_security_group" "project02-nsg" {
    name = var.network_security_group_name
    location = var.location
    resource_group_name = var.resource_group_name
    depends_on = [ azurerm_subnet.project02-subnet01 ]
}

resource "azurerm_network_security_rule" "security_rules" {
  for_each = var.nsg_security_rules

  name                        = each.key
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.project02-nsg.name
}


resource "azurerm_subnet_network_security_group_association" "nsg-to-subnet" {
  subnet_id                 = azurerm_subnet.project02-subnet01.id
  network_security_group_id = azurerm_network_security_group.project02-nsg.id
}