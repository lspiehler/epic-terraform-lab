resource "azurerm_recovery_services_vault" "recovery_services_vault" {
  for_each = {
    for vault in local.vaults : "${vault.key}" => vault
  }
  name = each.value.name
  location   = each.value.location
  resource_group_name = each.value.resource_group_name
  sku  = each.value.sku
  public_network_access_enabled = each.value.public_network_access_enabled
  storage_mode_type = each.value.storage_mode_type
  cross_region_restore_enabled = each.value.cross_region_restore_enabled
  tags = each.value.tags
}