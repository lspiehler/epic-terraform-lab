resource "azurerm_linux_virtual_machine" "linux_virtual_machine" {
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
  disable_password_authentication            = each.value.disable_password_authentication
  patch_assessment_mode     = each.value.patch_assessment_mode
  admin_username            = each.value.admin_username
  admin_password            = each.value.admin_password
  network_interface_ids     = each.value.network_interface_ids
  encryption_at_host_enabled = each.value.encryption_at_host_enabled  
  disk_controller_type      = each.value.disk_controller_type
  
  dynamic "admin_ssh_key" {
    for_each = each.value.admin_ssh_key == null ? [] : [1]
    content {
      username   = each.value.admin_ssh_key.username
      public_key = each.value.admin_ssh_key.public_key
    }
  }
  
  os_disk {
    name                 = each.value.os_disk.name
    caching              = each.value.os_disk.caching
    storage_account_type = each.value.os_disk.storage_account_type
    disk_size_gb         = each.value.os_disk.disk_size_gb
  }

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }

dynamic "plan" {
    for_each = each.value.plan == null ? [] : [1]
    content {
      name = each.value.plan.name
      product = each.value.plan.product
      publisher = each.value.plan.publisher
    }
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
      admin_ssh_key,
      identity
    ]
  }
  
}