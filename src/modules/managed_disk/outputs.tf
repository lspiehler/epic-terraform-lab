output "managed_disk" {
    description = "Disk resources"
    value = merge(azurerm_managed_disk.managed_disk, data.azurerm_managed_disk.managed_disk)
}