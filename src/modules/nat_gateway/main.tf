resource "azurerm_nat_gateway" "nat_gateway" {
  for_each = {
    for nat_gateway in local.nat_gateways : "${nat_gateway.key}" => nat_gateway if nat_gateway.existing == false
  }
  name = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku_name = each.value.sku_name
  tags                = each.value.tags
}

data "azurerm_nat_gateway" "nat_gateway" {
  for_each = {
    for nat_gateway in local.nat_gateways : "${nat_gateway.key}" => nat_gateway if nat_gateway.existing == true
  }
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}