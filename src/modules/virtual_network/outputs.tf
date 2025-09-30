output "virtual_network" {
    description = "VNETs"
    value = merge(azurerm_virtual_network.virtual_network, data.azurerm_virtual_network.vnet)
}