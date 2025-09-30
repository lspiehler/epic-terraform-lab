resource "azurerm_storage_account_network_rules" "storage_account_network_rules" {
  for_each = local.networkrules
  storage_account_id = each.value.storage_account_id

  default_action             = each.value.default_action
  ip_rules                   = each.value.ip_rules
  virtual_network_subnet_ids = each.value.virtual_network_subnet_ids
  bypass                     = each.value.bypass
}