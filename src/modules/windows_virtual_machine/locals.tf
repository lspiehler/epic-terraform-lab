locals {

  nics = {
    for vm_key, vm in var.windows : 
      "${vm_key}" => {
        for vm_count, vm_index in length(vm.names) > 0 ? vm.names : range(vm.count) :
          "${vm_index}" => {
            for nic_key, nic in vm.nics :
              "nics" => var.nic["${vm_index}.${nic_key}"].id...
          }
      }
  }

  zone_test = [
    for vm_key, vm in var.windows : {
      test = vm.zone == null && vm.virtual_machine_scale_set == null ? file("Error: Either a zone or virtual_machine_scale_set must be defined for \"${vm_key}\".") : "OK"
    }
  ]

  vms = flatten([
    for vm_key, vm in var.windows : [
      for vm_count, vm_index in length(vm.names) > 0 ? vm.names : range(vm.count) : {
        key = "${vm_index}"
        name                      = length(vm.names) > 0 ? vm_index : "${var.name_prefixes["vm"]}${format("${vm_key}${vm.delimeter}${vm.index_format}", vm_index)}${var.name_suffixes["vm"]}"
        #zone                      = length(vm.zones) == 1 ? vm.zones[0] : (vm_count % 2 == 0 ? vm.zones[0] : vm.zones[1])
        zone                      = vm.zone != null ? vm.zone : null
        resource_group_name       = var.resource_group[vm.resource_group].name
        location                  = vm.location != null ? vm.location : var.location
        size                      = vm.size
        virtual_machine_scale_set_id = vm.virtual_machine_scale_set == null ? null : var.mod_orchestrated_virtual_machine_scale_set[vm.virtual_machine_scale_set].id
        admin_username            = vm.admin_username
        admin_password            = var.secrets[vm.admin_password_secret]
        timezone                  = var.var_timezone != null ? var.var_timezone : vm.timezone
        patch_assessment_mode     = vm.patch_assessment_mode
        network_interface_ids     = local.nics[vm_key][vm_index].nics
        encryption_at_host_enabled = vm.encryption_at_host_enabled        
        license_type              = vm.license_type
        disk_controller_type      = vm.disk_controller_type
        secure_boot_enabled = vm.secure_boot_enabled

        os_disk = {
          name                 = length(vm.names) > 0 ? "${var.name_prefixes["disk"]}os-${var.name_prefixes["vm"]}${vm_index}${var.name_suffixes["disk"]}" : "${var.name_prefixes["disk"]}os-${var.name_prefixes["vm"]}${format("${vm_key}${vm.delimeter}${vm.index_format}", vm_index)}${var.name_suffixes["vm"]}${var.name_suffixes["disk"]}"
          caching              = vm.os_disk.caching
          storage_account_type = vm.os_disk.storage_account_type
        }

        source_image_reference = vm.source_image_reference

        identity = vm.identity == null ? null : {
          type = vm.identity.type
        }

        boot_diagnostics = vm.boot_diagnostics == null ? null : {
          storage_account_uri = var.storage_accounts[vm.boot_diagnostics.storage_account].primary_blob_endpoint
        }

        tags = merge(var.var_default_tags, vm.tags)
      }
    ]
  ])
}