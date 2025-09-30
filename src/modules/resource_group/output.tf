output "resource_group" {
    description = "Resource groups"
    value = merge(azurerm_resource_group.resource_group, data.azurerm_resource_group.resource_group)
}