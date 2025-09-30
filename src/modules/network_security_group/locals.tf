locals {
 nsgs = flatten([
    for nsg_key, nsg in var.var_nsgs : {
        key = "${nsg_key}"
        name = nsg.name != null ? nsg.name : "${var.var_name_prefixes["nsg"]}${nsg_key}${var.var_name_suffixes["nsg"]}"
        location = nsg.location != null ? nsg.location : var.var_location
        resource_group_name = var.mod_resource_group[nsg.resource_group].name
        existing = nsg.existing
        tags = merge(var.var_default_tags, nsg.tags)
    }
  ])
}