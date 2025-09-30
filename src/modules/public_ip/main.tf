##Create all resource groups defined in the variable "rgs"
resource "azurerm_public_ip" "public_ip" {
  for_each = {
    for public_ip in local.public_ips : "${public_ip.key}" => public_ip if public_ip.existing == false
  }
  name = each.value.name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method = each.value.allocation_method
  tags = each.value.tags
}

##Get references to all existing resource groups defined in the variable "rgs"
data "azurerm_public_ip" "public_ip" {
  for_each = {
    for public_ip in local.public_ips : "${public_ip.key}" => public_ip if public_ip.existing == true
  }
  name = each.value.name
  resource_group_name = each.value.resource_group_name
}

##Allows for lock level on resource
resource "azurerm_management_lock" "public_ip" {
  for_each = {
    for public_ip in local.public_ips : "${public_ip.key}" => public_ip if public_ip.management_lock != null
  }
  name = each.value.management_lock.name != null ? each.value.management_lock.name : "${var.name_prefixes["management_lock"]}${each.value.name}${var.name_suffixes["management_lock"]}"
  scope = azurerm_public_ip.public_ip[each.key].id
  lock_level = each.value.management_lock.lock_level
  notes = each.value.management_lock.notes
}
