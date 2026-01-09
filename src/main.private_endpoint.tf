module "private_endpoint" {
  source = "./modules/private_endpoint"
  var_private_endpoints = var.private_endpoints
  mod_resource_group = module.resource_group.resource_group
  mod_subnet = module.subnet.subnet
  var_location = var.location
  mod_storage_account = module.storage_account.resource
  mod_automation_account = module.automation_account.automation_account
  mod_private_dns_zone = module.private_dns_zone.private_dns_zone
  var_name_prefixes = var.name_prefixes
  var_name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}
