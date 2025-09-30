output "network_security_group" {
    description = "Network security group resources"
    value = merge(azurerm_network_security_group.network_security_group, data.azurerm_network_security_group.network_security_group)
}