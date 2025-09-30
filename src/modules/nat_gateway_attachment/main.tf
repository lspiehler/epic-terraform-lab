resource "azurerm_subnet_nat_gateway_association" "nat_gateway_association" {
  for_each = {
    for nat_gateway_attachment in local.nat_gateway_attachments : "${nat_gateway_attachment.key}" => nat_gateway_attachment
  }
  subnet_id      = each.value.subnet
  nat_gateway_id = each.value.nat_gateway
}
