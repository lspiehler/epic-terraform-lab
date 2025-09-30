resource "azurerm_virtual_network" "virtual_network" {
  for_each = {
    for vnet in local.vnets : "${vnet.key}" => vnet if vnet.existing == false
  }
  name = each.value.name
  #checkov:skip=CKV2_AZURE_31:Checkov is falsely reporting that the subnet is not associated with a network security group
  location   = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space  = each.value.address_space
  dns_servers = each.value.dns_servers
  tags = each.value.tags
}

data "azurerm_virtual_network" "vnet" {
  for_each = {
    for vnet in local.vnets : "${vnet.key}" => vnet if vnet.existing == true
  }
  name = each.value.name
  resource_group_name = each.value.resource_group_name
}