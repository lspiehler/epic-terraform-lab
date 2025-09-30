resource "azurerm_nat_gateway_public_ip_association" "nat_gateway_public_ip_association" {
  for_each = {
    for nat_gateway_ip in local.nat_gateway_ips : "${nat_gateway_ip.key}" => nat_gateway_ip
  }
  nat_gateway_id = each.value.nat_gateway_id
  public_ip_address_id = each.value.public_ip_address_id
}
