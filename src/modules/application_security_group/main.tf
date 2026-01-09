resource "azurerm_application_security_group" "application_security_group" {
  for_each = {
    for asg in local.asgs : "${asg.key}" => asg if asg.existing == false
  }
  name = each.value.name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  tags = each.value.tags
}

data "azurerm_application_security_group" "application_security_group" {
  for_each = {
    for asg in local.asgs : "${asg.key}" => asg if asg.existing == true
  }
  name = each.value.name
  resource_group_name = each.value.resource_group_name
}