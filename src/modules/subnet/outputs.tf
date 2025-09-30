output "subnet" {
    description = "Subnets"
    value = merge(azurerm_subnet.subnet, data.azurerm_subnet.subnet)
}