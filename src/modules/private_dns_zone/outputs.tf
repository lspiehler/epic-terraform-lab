output "private_dns_zone" {
    description = "Private DNS Zones"
    value = merge(azurerm_private_dns_zone.private_dns_zone, data.azurerm_private_dns_zone.private_dns_zone)
}