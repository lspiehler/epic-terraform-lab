locals {
  nat_gateways = flatten([
    for nat_gateway_key, nat_gateway in var.nat_gateway : {
        key = "${nat_gateway_key}"
        location = nat_gateway.location != null ? nat_gateway.location : var.location
        name = nat_gateway.name != null ? nat_gateway.name : "${var.name_prefixes["nat_gateway"]}${nat_gateway_key}${var.name_suffixes["nat_gateway"]}"
        resource_group_name = var.mod_resource_group[nat_gateway.resource_group].name
        sku_name = nat_gateway.sku_name
        existing = nat_gateway.existing
        tags = merge(var.var_default_tags, nat_gateway.tags)
    }
  ])
}