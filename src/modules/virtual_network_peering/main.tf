resource "azurerm_virtual_network_peering" "virtual_network_peering" {
  for_each = {
    for peering in local.peerings : "${peering.key}" => peering
  }
  name = each.value.name
  resource_group_name = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  remote_virtual_network_id = each.value.remote_virtual_network_id
}