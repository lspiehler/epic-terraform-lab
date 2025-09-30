module "private_endpoint" {
  source = "./modules/private_endpoint"
  private_endpoints = var.private_endpoints
  resource_group = module.resource_group.resource_group
  subnet = module.subnet.subnet
  location = var.location
  storage_account = module.storage_account.resource
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}