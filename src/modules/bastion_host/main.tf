resource "azurerm_bastion_host" "bastion_host" {
  for_each = {
    for bastion_host in local.bastion_host : "${bastion_host.key}" => bastion_host
  }
  name = each.value.name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  tunneling_enabled = each.value.tunneling_enabled
  sku = each.value.sku
  ip_configuration {
    name = each.value.ip_configuration.name
    subnet_id = each.value.ip_configuration.subnet_id
    public_ip_address_id = each.value.ip_configuration.public_ip_address_id
  }
  tags = each.value.tags
}