##Create all public_ips defined in the variable "public_ips"
module "private_dns_zone" {
  source = "./modules/private_dns_zone"
  var_private_dns_zones = var.private_dns_zones
  mod_resource_group = module.resource_group.resource_group
  var_name_prefixes = var.name_prefixes
  var_name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}
