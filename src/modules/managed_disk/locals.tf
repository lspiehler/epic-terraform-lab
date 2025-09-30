locals {
  
  nested_disks = flatten([
    for vm_type_key, vms in var.vms : [
      for vm_key, vm in vms : [
        for vm_count, vm_index in length(vm.names) > 0 ? vm.names : range(vm.count) : [
          for disk_key, disk in vm.disks : {
            count = vm.count
            key = "${vm_index}.${disk_key}"
            #zone = length(vm.zones) == 1 ? vm.zones[0] : (vm_count % 2 == 0 ? vm.zones[0] : vm.zones[1])
            zone = var.mod_vms[vm_type_key]["${vm_index}"].zone != null ? var.mod_vms[vm_type_key]["${vm_index}"].zone : file("Error: Zone is not defined for \"${var.mod_vms[vm_type_key]["${vm_index}"].name}\". Zone must be defined for VMs with nested disks because zone cannot be determined for disks attached to VMs in a VMSS.")
            name = disk.name != null ? disk.name : (length(vm.names) > 0 ? "${var.name_prefixes["disk"]}${disk_key}-${vm_index}${var.name_suffixes["disk"]}" : "${var.name_prefixes["disk"]}${disk_key}-${var.name_prefixes["vm"]}${format("${vm_key}${vm.delimeter}${vm.index_format}", vm_index)}${var.name_suffixes["vm"]}${var.name_suffixes["disk"]}")
            location = vm.location != null ? vm.location : var.location
            resource_group_name = var.resource_group[vm.resource_group].name
            storage_account_type = disk.storage_account_type
            existing = false
            # network_access_policy = disk.network_access_policy
            # public_network_access_enabled = disk.public_network_access_enabled
            create_option = disk.create_option
            source_resource_id = disk.source_resource_id
            disk_size_gb = disk.disk_size_gb
            disk_iops_read_write = disk.disk_iops_read_write
            disk_mbps_read_write = disk.disk_mbps_read_write
            tags = merge({
              disk_label = disk_key
            }, var.var_default_tags, disk.tags)
          } if disk.external_disk == null
        ]
      ]
    ]
  ])

  storagecheck = [
    for vm_type_key, vms in var.vms : [
      for vm_key, vm in vms : [
        for vm_count, vm_index in length(vm.names) > 0 ? vm.names : range(vm.count) : [
          for disk_key, disk in vm.disks : {
            test = disk.external_disk != null && vm.count > 1 || length(vm.names) > 1 ? file("Error: external storage reference for VM configuration \"${vm_key}\" is not support for more than 1 VM.") : "OK"
          }
        ]
      ]
    ]
  ]

  external_disks = flatten([
    for disk_key, disk in var.var_managed_disks : {
      key = "${disk_key}"
      zone = disk.zone != null || disk.existing == true ? disk.zone : file("Error: Zone must be defined for external disk \"${disk_key}\" unless importing an existing disk.")
      name = disk.name != null ? disk.name : "${var.name_prefixes["disk"]}${disk_key}${var.name_suffixes["disk"]}"
      location = var.location != null ? var.location : (disk.location != null || disk.existing == true ? disk.location : file("Error: Either a global location or disk location attribute must be defined for external disk \"${disk_key}\" unless importing an existing disk"))
      resource_group_name = var.resource_group[disk.resource_group].name
      storage_account_type = disk.storage_account_type
      existing = disk.existing
      # network_access_policy = disk.network_access_policy
      # public_network_access_enabled = disk.public_network_access_enabled
      create_option = disk.create_option
      source_resource_id = disk.source_resource_id
      disk_size_gb = disk.disk_size_gb
      disk_iops_read_write = disk.disk_iops_read_write
      disk_mbps_read_write = disk.disk_mbps_read_write
      tags = merge({
        disk_label = disk_key
      }, var.var_default_tags, disk.tags)
    }
  ])

  disks = flatten([local.nested_disks, local.external_disks])
}