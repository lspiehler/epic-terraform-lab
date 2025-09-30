locals {
  
  bastion_host = flatten([
    for bastion_key, bastion_host in var.bastion_host : {
        key = "${bastion_key}"
        name = "${var.name_prefixes["bastion"]}${bastion_key}${var.name_suffixes["bastion"]}"
        location = bastion_host.location != null ? bastion_host.location : var.location
        resource_group_name = var.resource_group[bastion_host.resource_group].name
        tunneling_enabled = bastion_host.tunneling_enabled
        sku = bastion_host.sku
        ip_configuration = {
            name = "configuration"
            subnet_id = var.subnet[bastion_host.ip_configuration.subnet].id
            public_ip_address_id = var.public_ips[bastion_host.ip_configuration.public_ip_address].id
        }
        tags = merge(var.var_default_tags, bastion_host.tags)
    }
  ])
}