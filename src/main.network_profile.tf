module "network_profile" {
  source = "./modules/network_profile"
  var_network_profile = var.network_profile
  mod_resource_group = module.resource_group.resource_group
  mod_application_security_group = module.application_security_group.application_security_group
  mod_subnet = module.subnet.subnet
  location = var.location
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}
