output "public_ip" {
    description = "Resource groups"
    value = merge(azurerm_public_ip.public_ip, data.azurerm_public_ip.public_ip)
}