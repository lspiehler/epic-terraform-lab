##Create disks for each VM based on the disks attribute within the variable "vms"
module "managed_disk" {
  source = "./modules/managed_disk"
  vms = {
    windows = var.windows_vms
    linux = var.linux_vms
  }
  mod_vms = {
    windows = module.windows_virtual_machine.windows_virtual_machine
    linux = module.linux_virtual_machine.linux_virtual_machine
  }
  var_managed_disks = var.managed_disks
  resource_group = module.resource_group.resource_group
  location = var.location
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}

##Create Virtual Machines based on the variable "vms"
module "windows_virtual_machine" {
  source = "./modules/windows_virtual_machine"
  windows = var.windows_vms
  mod_orchestrated_virtual_machine_scale_set = module.orchestrated_virtual_machine_scale_set.orchestrated_virtual_machine_scale_set
  resource_group = module.resource_group.resource_group
  storage_accounts = module.storage_account.resource
  nic = module.network_interface.network_interface
  location = var.location
  var_timezone = var.timezone
  secrets = local.secrets
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}

##Create VM extensions
module "virtual_machine_extension" {
  source = "./modules/virtual_machine_extension"
  var_vms = {
    windows = var.windows_vms
    linux = var.linux_vms
  }
  mod_vms = {
    windows = module.windows_virtual_machine.windows_virtual_machine
    linux = module.linux_virtual_machine.linux_virtual_machine
  }
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}

module "linux_virtual_machine" {
  source = "./modules/linux_virtual_machine"
  linux = var.linux_vms
  mod_orchestrated_virtual_machine_scale_set = module.orchestrated_virtual_machine_scale_set.orchestrated_virtual_machine_scale_set
  resource_group = module.resource_group.resource_group
  storage_accounts = module.storage_account.resource
  nic = module.network_interface.network_interface
  location = var.location
  secrets = local.secrets
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}

##attach disks to their associated VMs
module "virtual_machine_data_disk_attachment" {
  source = "./modules/virtual_machine_data_disk_attachment"
  vms = {
    windows = var.windows_vms
    linux = var.linux_vms
  }
  vm_resources = {
    windows = module.windows_virtual_machine.windows_virtual_machine
    linux = module.linux_virtual_machine.linux_virtual_machine
  }
  disk = module.managed_disk.managed_disk
}

module "orchestrated_virtual_machine_scale_set" {
  source = "./modules/orchestrated_virtual_machine_scale_set"
  var_vmss = var.vmss
  var_location = var.location
  mod_resource_group = module.resource_group.resource_group
  var_name_prefixes = var.name_prefixes
  var_name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}