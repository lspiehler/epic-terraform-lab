module "application_security_group" {
  source = "./modules/application_security_group"
  var_application_security_group = var.application_security_group
  mod_resource_group = module.resource_group.resource_group
  location = var.location
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}
