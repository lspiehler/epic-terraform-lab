output "storage_share" {
    description = "Storage shares"
    value = merge(azurerm_storage_share.storage_share, data.azurerm_storage_share.storage_share)
}