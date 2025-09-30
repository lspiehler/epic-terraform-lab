##Create all application gateways defined in the variable "agws"
module "lb" {
  source = "./modules/lb"
  load_balancers = var.load_balancer
  resource_group = module.resource_group.resource_group
  subnet = module.subnet.subnet
  vnet = module.virtual_network.virtual_network
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