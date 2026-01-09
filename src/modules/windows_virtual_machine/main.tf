resource "azurerm_windows_virtual_machine" "windows_virtual_machine" {
  for_each = {
    for vm in local.vms : "${vm.key}" => vm
  }
  name                      = each.value.name
  #checkov:skip=CKV_AZURE_151:Investigate
  #checkov:skip=CKV_AZURE_50:Investigate
  zone                      = each.value.zone
  resource_group_name       = each.value.resource_group_name
  location                  = each.value.location
  size                      = each.value.size
  virtual_machine_scale_set_id = each.value.virtual_machine_scale_set_id
  admin_username            = each.value.admin_username
  admin_password            = each.value.admin_password
  timezone                  = each.value.timezone
  patch_assessment_mode     = each.value.patch_assessment_mode
  network_interface_ids     = each.value.network_interface_ids
  encryption_at_host_enabled = each.value.encryption_at_host_enabled  
  license_type               = each.value.license_type
  disk_controller_type      = each.value.disk_controller_type
  secure_boot_enabled       = each.value.secure_boot_enabled

  os_disk {
    name                 = each.value.os_disk.name
    caching              = each.value.os_disk.caching
    storage_account_type = each.value.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }

  dynamic "identity" {
    for_each = each.value.identity == null ? [] : [1]
    content {
      type = each.value.identity.type
    }
  } 

  dynamic "boot_diagnostics" {
    for_each = each.value.boot_diagnostics == null ? [] : [1]
    content {
      storage_account_uri = each.value.boot_diagnostics.storage_account_uri
    }
  }
  
  tags = each.value.tags
  
  lifecycle {
    ignore_changes = [
      zone,
      admin_password,
      timezone,
      identity
    ]
  }

}