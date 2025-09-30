output "nat_gateway" {
    description = "NAT Gateways"
    value = merge(azurerm_nat_gateway.nat_gateway, data.azurerm_nat_gateway.nat_gateway)
}