##Create all resource groups defined in the variable "rgs"
resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  for_each = {
    for uai in local.user_assigned_identity : "${uai.key}" => uai if uai.existing == false
  }
  name = each.value.name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  tags = each.value.tags
}

##Get references to all existing resource groups defined in the variable "rgs"
data "azurerm_user_assigned_identity" "user_assigned_identity" {
  for_each = {
    for uai in local.user_assigned_identity : "${uai.key}" => uai if uai.existing == true
  }
  name = each.value.name
  resource_group_name = each.value.resource_group_name
}

##Allows for lock level on resource
resource "azurerm_management_lock" "user_assigned_identity" {
  for_each = {
    for uai in local.user_assigned_identity : "${uai.key}" => uai if uai.management_lock != null
  }
  name = each.value.management_lock.name != null ? each.value.management_lock.name : "${var.var_name_prefixes["management_lock"]}${each.value.name}${var.var_name_suffixes["management_lock"]}"
  scope = azurerm_user_assigned_identity.user_assigned_identity[each.key].id
  lock_level = each.value.management_lock.lock_level
  notes = each.value.management_lock.notes
}
