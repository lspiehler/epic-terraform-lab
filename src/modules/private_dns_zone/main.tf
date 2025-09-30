resource "azurerm_private_dns_zone" "private_dns_zone" {
  for_each = {
    for zone in local.private_dns_zones : "${zone.key}" => zone if zone.existing == false
  }
  name = each.value.name
  resource_group_name = each.value.resource_group_name
  tags = each.value.tags
}

data "azurerm_private_dns_zone" "private_dns_zone" {
  for_each = {
    for zone in local.private_dns_zones : "${zone.key}" => zone if zone.existing == true
  }
  name = each.value.name
  resource_group_name = each.value.resource_group_name
}