resource "azurerm_network_interface" "network_interface" {
  for_each = {
    for nic in local.nics : "${nic.key}" => nic
  }
  name = each.value.name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  accelerated_networking_enabled = each.value.accelerated_networking_enabled
  ip_forwarding_enabled = each.value.ip_forwarding_enabled
  dynamic "ip_configuration" {
    for_each = each.value.ip_configuration
    content {
      name = ip_configuration.value.name
      subnet_id = ip_configuration.value.subnet_id
      primary = ip_configuration.value.primary
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
      private_ip_address = ip_configuration.value.private_ip_address
    }
  }
  tags = each.value.tags
}