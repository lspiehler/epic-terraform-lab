locals {
  backups = flatten([
    for vm_type_key, vms in var.vms : [
      for vm_key, vm in vms : [
        for vm_count, vm_index in length(vm.names) > 0 ? vm.names : range(vm.count) : {
          key                 = "${vm_index}"
          resource_group_name = var.vault_resources[vm.backupvault].resource_group_name
          recovery_vault_name = var.vault_resources[vm.backupvault].name
          source_vm_id        = var.vm_resources[vm_type_key]["${vm_index}"].id
          backup_policy_id    = var.policy_resources[vm.backuppolicy].id
        } if vm.backuppolicy != null && vm.backupvault != null
      ]
    ]
  ])
}
