resource "azurerm_private_endpoint" "private_endpoint" {
  for_each = {
    for private_endpoint in local.peps : "${private_endpoint.key}" => private_endpoint
  }
  name = each.value.name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  subnet_id = each.value.subnet_id
  private_service_connection {
    name = each.value.private_service_connection.name
    private_connection_resource_id = each.value.private_service_connection.private_connection_resource_id
    subresource_names = each.value.private_service_connection.subresource_names
    is_manual_connection = each.value.private_service_connection.is_manual_connection
  }
  tags = each.value.tags

  lifecycle {
    ignore_changes = [ 
      private_dns_zone_group
    ]
  }
}
