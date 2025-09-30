resource "azurerm_managed_disk" "managed_disk" {
  for_each = {
    for disk in local.disks : "${disk.key}" => disk if disk.existing == false
  }
  name = each.value.name
  #checkov:skip=CKV_AZURE_93:Investigate
  zone = each.value.zone
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  storage_account_type = each.value.storage_account_type
  # network_access_policy = each.value.network_access_policy
  # public_network_access_enabled = each.value.public_network_access_enabled
  create_option = each.value.create_option
  source_resource_id = each.value.source_resource_id
  disk_size_gb = each.value.disk_size_gb
  disk_iops_read_write = each.value.disk_iops_read_write
  disk_mbps_read_write = each.value.disk_mbps_read_write
  tags = each.value.tags
}

data "azurerm_managed_disk" "managed_disk" {
  for_each = {
    for disk in local.disks : "${disk.key}" => disk if disk.existing == true
  }
  name = each.value.name
  #checkov:skip=CKV_AZURE_93:Investigate
  resource_group_name = each.value.resource_group_name
}