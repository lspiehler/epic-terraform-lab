resource "azurerm_storage_share" "storage_share" {
  for_each = {
    for share in local.shares : "${share.key}" => share
  }
  name = each.value.name
  storage_account_id  = each.value.storage_account_id
  access_tier           = each.value.access_tier
  enabled_protocol      = each.value.enabled_protocol
  quota                 = each.value.quota
}