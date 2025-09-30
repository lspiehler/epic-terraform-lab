##Create all resource groups defined in the variable "rgs"
resource "azurerm_resource_group" "resource_group" {
  for_each = { for k, v in var.resource_group : k => v if v.existing == false }
  name      = var.resource_group[each.key].name != null ? var.resource_group[each.key].name : "${var.name_prefixes["rg"]}${each.key}${var.name_suffixes["rg"]}"
  location = var.resource_group[each.key].location != null ? var.resource_group[each.key].location : var.location
  tags = merge(var.var_default_tags, var.resource_group[each.key].tags)
}

##Get references to all existing resource groups defined in the variable "rgs"
data "azurerm_resource_group" "resource_group" {
  for_each = { for k, v in var.resource_group : k => v if v.existing == true }
  name      = var.resource_group[each.key].name != null ? var.resource_group[each.key].name : "${var.name_prefixes["rg"]}${each.key}${var.name_suffixes["rg"]}"
}