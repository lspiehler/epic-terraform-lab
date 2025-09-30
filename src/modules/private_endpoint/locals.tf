locals { 
  peps = flatten([
    for pep_key, pep in var.private_endpoints : {
        key = "${pep_key}"
        name = pep.name != null ? pep.name : "${var.name_prefixes["pep"]}${pep_key}${var.name_suffixes["pep"]}"
        location = pep.location != null ? pep.location : var.location
        resource_group_name = var.resource_group[pep.resource_group].name
        subnet_id = var.subnet[pep.subnet].id
        private_service_connection = {
            name = pep.name != null ? "${pep.name}-connection" : "${var.name_prefixes["pep"]}${pep_key}${var.name_suffixes["pep"]}-connection"
            private_connection_resource_id = var.storage_account[pep.private_service_connection.private_connection_resource_id].id
            subresource_names = pep.private_service_connection.subresource_names
            is_manual_connection = pep.private_service_connection.is_manual_connection
        }
        tags = merge(var.var_default_tags, pep.tags)
    }
  ])
}
