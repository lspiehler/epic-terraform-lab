resource "azurerm_automation_account" "automation_account" {
  for_each = {
    for automation_account in local.automation_accounts : "${automation_account.key}" => automation_account
  }
  name = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku_name = each.value.sku_name
  local_authentication_enabled = each.value.local_authentication_enabled
  public_network_access_enabled = each.value.public_network_access_enabled

  dynamic "identity" {
    for_each = each.value.identity == null ? [] : [1]
    content {
      type = each.value.identity.type
    }
  }

  tags                = each.value.tags
}
