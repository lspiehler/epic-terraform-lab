##Create all application gateways defined in the variable "agws"
module "application_gateway" {
  source = "./modules/application_gateway"
  agws = var.agws
  resource_group = module.resource_group.resource_group
  subnet = module.subnet.subnet
  nic = module.network_interface.network_interface
  vms = {
    windows = var.windows_vms
    linux = var.linux_vms
  }
  vm_resources = {
    windows = module.windows_virtual_machine.windows_virtual_machine
    linux = module.linux_virtual_machine.linux_virtual_machine
  }
  public_ips = module.public_ip.public_ip
  location = var.location
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}