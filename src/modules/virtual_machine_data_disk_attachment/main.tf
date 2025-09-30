resource "azurerm_virtual_machine_data_disk_attachment" "virtual_machine_data_disk_attachment" {
  for_each = {
    for attachment in local.attach_disks : "${attachment.key}" => attachment
  }
  managed_disk_id    = each.value.managed_disk_id
  virtual_machine_id = each.value.virtual_machine_id
  lun                = each.value.lun
  caching            = each.value.caching
}