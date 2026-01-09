resource "azurerm_network_profile" "network_profile" {
  for_each = {
    for network_profile in local.network_profiles : "${network_profile.key}" => network_profile
  }
  name = each.value.name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  tags = each.value.tags
  container_network_interface {
    name = each.value.container_network_interface.name
    dynamic ip_configuration {
      for_each = each.value.container_network_interface.ip_configuration
      content {
        name = ip_configuration.value.name
        subnet_id = ip_configuration.value.subnet
        # application_security_group_ids = ip_configuration.value.application_security_group_ids
      }
    }
  }
}
