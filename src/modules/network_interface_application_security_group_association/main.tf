resource "azurerm_network_interface_application_security_group_association" "network_interface_application_security_group_association" {
  for_each = {
    for association in local.associations : "${association.key}" => association
  }
  network_interface_id = each.value.network_interface_id
  application_security_group_id = each.value.application_security_group_id
}