resource "azurerm_subnet" "subnet" {
  for_each = {
    for subnet in local.subnets : "${subnet.key}" => subnet if subnet.existing == false
  }
  name = each.value.name
  #checkov:skip=CKV2_AZURE_31:Checkov is falsely reporting that the subnet is not associated with a network security group
  resource_group_name   = each.value.resource_group_name
  virtual_network_name  = each.value.virtual_network_name
  address_prefixes      = each.value.address_prefixes
  service_endpoints     = each.value.service_endpoints
  default_outbound_access_enabled = each.value.default_outbound_access_enabled
  private_endpoint_network_policies     = each.value.private_endpoint_network_policies

  dynamic "delegation" {
    for_each = each.value.delegation == null ? [] : [1]
    content {
      name = each.value.delegation.name
      service_delegation {
        name = each.value.delegation.service_delegation.name
        actions = each.value.delegation.service_delegation.actions
      }
    }
  }
}

data "azurerm_subnet" "subnet" {
  for_each = {
    for subnet in local.subnets : "${subnet.key}" => subnet if subnet.existing == true
  }
  name = each.value.name
  resource_group_name   = each.value.resource_group_name
  virtual_network_name  = each.value.virtual_network_name
}