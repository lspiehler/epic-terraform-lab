locals {
  
  private_dns_zones = flatten([
    for private_zone_key, private_zone in var.var_private_dns_zones : {
      key = private_zone_key
      name = private_zone.name != null ? private_zone.name : "${var.var_name_prefixes["private_dns_zone"]}${private_zone_key}${var.var_name_suffixes["private_dns_zone"]}"
      existing = private_zone.existing
      resource_group_name = var.mod_resource_group[private_zone.resource_group].name
      tags = merge(var.var_default_tags, private_zone.tags)
    }
  ])
}