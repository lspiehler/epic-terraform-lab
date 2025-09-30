output "resource" {
    description = "Storage accounts"
    value = merge(azurerm_storage_account.storage_accounts, data.azurerm_storage_account.storage_accounts)
}