resource "azurerm_subnet_network_security_group_association" "network_security_group_association" {
  for_each = {
    for association in local.associations : "${association.key}" => association
  }
  subnet_id = each.value.subnet_id
  network_security_group_id = each.value.network_security_group_id

  depends_on = [ var.mod_network_security_rule ]
}