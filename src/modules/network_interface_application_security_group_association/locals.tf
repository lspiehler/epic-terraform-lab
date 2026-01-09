locals {
  associations = flatten([
    for vm_type_key, vms in var.vms : [
      for vm_key, vm in vms : [
        for vm_count, vm_index in length(vm.names) > 0 ? vm.names : range(vm.count) : [
          for nic_key, nic in vm.nics : [
            for association_index, association in nic.application_security_groups : {
              count = vm.count
              key = "${vm_index}.${nic_key}.${association_index}"
              network_interface_id = var.mod_nic["${vm_index}.${nic_key}"].id
              application_security_group_id = var.mod_application_security_group[association].id
            }
          ]
        ]
      ]
    ]
  ])
}