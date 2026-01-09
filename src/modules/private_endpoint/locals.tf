locals {

  types = {
    storage_account = var.mod_storage_account
    automation_account = var.mod_automation_account
  }  

  peps = flatten([
    for pep_key, pep in var.var_private_endpoints : {
        key = "${pep_key}"
        name = pep.name != null ? pep.name : "${var.var_name_prefixes["pep"]}${pep_key}${var.var_name_suffixes["pep"]}"
        location = pep.location != null ? pep.location : var.var_location
        resource_group_name = var.mod_resource_group[pep.resource_group].name
        subnet_id = var.mod_subnet[pep.subnet].id
        private_service_connection = {
            name = pep.name != null ? "${pep.name}-connection" : "${var.var_name_prefixes["pep"]}${pep_key}${var.var_name_suffixes["pep"]}-connection"
            private_connection_resource_id = local.types[pep.private_service_connection.private_connection_resource_type][pep.private_service_connection.private_connection_resource].id
            subresource_names = pep.private_service_connection.subresource_names
            is_manual_connection = pep.private_service_connection.is_manual_connection
        }
        private_dns_zone_group = pep.private_dns_zone_group != null ? {
            name = pep.private_dns_zone_group.name != null ? pep.private_dns_zone_group.name : "${var.var_name_prefixes["private_dns_zone_group"]}${pep_key}${var.var_name_suffixes["private_dns_zone_group"]}"
            private_dns_zone_ids = length(pep.private_dns_zone_group.private_dns_zones) == 0 ? [] : [
              for k, v in var.mod_private_dns_zone : v.id if contains(pep.private_dns_zone_group.private_dns_zones, k)
            ]
        } : null
        tags = merge(var.var_default_tags, pep.tags)
    }
  ])
}
