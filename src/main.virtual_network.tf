##Create all network security groups defined in the variable "nsgs"
module "network_security_group" {
  source = "./modules/network_security_group"
  var_nsgs = var.nsgs
  var_location = var.location
  mod_resource_group = module.resource_group.resource_group
  var_name_prefixes = var.name_prefixes
  var_name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}

##Create all VNets defined in the variable "networks"
module "virtual_network" {
  source = "./modules/virtual_network"
  networks = var.networks
  resource_group = module.resource_group.resource_group
  location = var.location
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}

##For each VNet defined in the variable "networks" peer this together with other VNets defined in the attribute "peerings"
module "virtual_network_peering" {
  source = "./modules/virtual_network_peering"
  networks = var.networks
  resource_group = module.resource_group.resource_group
  vnet = module.virtual_network.virtual_network
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
}

##For each VNet defined in the variable "networks" create a subnet for every subnet defined in the attribute "subnets"
module "subnet" {
  source = "./modules/subnet"
  networks = var.networks
  resource_group = module.resource_group.resource_group
  vnet = module.virtual_network.virtual_network
  location = var.location
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
}

##Associate each subnet with its NSG as defined by the same index
module "network_security_group_association" {
  source = "./modules/network_security_group_association"
  networks = var.networks
  subnet = module.subnet.subnet
  nsg = module.network_security_group.network_security_group
  mod_network_security_rule = module.network_security_rule.network_security_rule
}

module "network_interface_application_security_group_association" {
  source = "./modules/network_interface_application_security_group_association"
  vms = {
    windows = var.windows_vms
    linux = var.linux_vms
  }
  mod_nic = module.network_interface.network_interface
  mod_application_security_group = module.application_security_group.application_security_group
}

##Create the rules for each NSG. Each NSG has rules defined by the rules attribute within the variable NSGs
##Rules are set by the name with destination port and source address defined via the rules variable
module "network_security_rule" {
  source = "./modules/network_security_rule"
  rules = var.rules
  resource_group = module.resource_group.resource_group
  mod_application_security_group = module.application_security_group.application_security_group
  nsg_vars = var.nsgs
  nsg = module.network_security_group.network_security_group
}

##Create NICs for each VM based on the nics attribute within the variable "vms"
module "network_interface" {
  source = "./modules/network_interface"
  vms = {
    windows = var.windows_vms
    linux = var.linux_vms
  }
  resource_group = module.resource_group.resource_group
  subnet = module.subnet.subnet
  location = var.location
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}

# output "ip_configs" {
#   value = module.network_interface.ip_configs
# }

# output "ip_config_index" {
#   value = module.network_interface.ip_config_index
# }