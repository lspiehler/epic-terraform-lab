module "public_ip" {
  source = "./modules/public_ip"
  public_ips = var.public_ips
  location = var.location
  resource_group = module.resource_group.resource_group
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}