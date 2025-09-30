module "recovery_services_vault" {
  source = "./modules/recovery_services_vault"
  recovery_vaults = var.recovery_vaults
  resource_group = module.resource_group.resource_group
  location = var.location
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}

module "backup_policy_vm" {
  source = "./modules/backup_policy_vm"
  vm_backup_policies = var.vm_backup_policies
  vault_resources = module.recovery_services_vault.recovery_services_vault
  resource_group = module.resource_group.resource_group
  var_timezone = var.timezone
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
}


module "backup_protected_vm" {
  source = "./modules/backup_protected_vm"
  vms = {
    windows = var.windows_vms
    linux = var.linux_vms
  }
  vm_resources = {
    windows = module.windows_virtual_machine.windows_virtual_machine
    linux = module.linux_virtual_machine.linux_virtual_machine
  }  
  vault_resources = module.recovery_services_vault.recovery_services_vault
  policy_resources = module.backup_policy_vm.backup_policy_vm
  resource_group = module.resource_group.resource_group
}

module "backup_policy_file_share" {
  source = "./modules/backup_policy_file_share"
  fs_backup_policies = var.fs_backup_policies
  vault_resources = module.recovery_services_vault.recovery_services_vault
  resource_group = module.resource_group.resource_group
  var_timezone = var.timezone
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
}
