##Create all network security groups defined in the variable "nsgs"
resource "azurerm_network_security_group" "network_security_group" {
  for_each = {
    for nsg in local.nsgs : "${nsg.key}" => nsg if nsg.existing == false
  }
  name = each.value.name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  tags = each.value.tags
}

##Get references to all existing network security groups defined in the variable "nsgs"
data "azurerm_network_security_group" "network_security_group" {
  for_each = {
    for nsg in local.nsgs : "${nsg.key}" => nsg if nsg.existing == true
  }
  name = each.value.name
  resource_group_name = each.value.resource_group_name
}