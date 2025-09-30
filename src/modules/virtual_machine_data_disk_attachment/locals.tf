locals {
  attach_disks = flatten([
    for vm_type_key, vms in var.vms : [
      for vm_key, vm in vms : [
        for vm_count, vm_index in length(vm.names) > 0 ? vm.names : range(vm.count) : [
          for disk_key, disk in vm.disks : {
            key                = "${vm_index}.${disk_key}"
            managed_disk_id    = disk.external_disk != null ? var.disk[disk.external_disk].id : var.disk["${vm_index}.${disk_key}"].id
            virtual_machine_id = var.vm_resources[vm_type_key]["${vm_index}"].id
            lun                = disk.lun
            caching            = disk.caching
          }
        ]
      ]
    ]
  ])
}