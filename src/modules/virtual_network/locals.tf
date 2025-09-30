locals {
  vnets = flatten([
    for network_key, network in var.networks : {
        key = "${network_key}"
        location = network.location != null ? network.location : var.location
        name = network.name != null ? network.name : "${var.name_prefixes["vnet"]}${network_key}${var.name_suffixes["vnet"]}"
        resource_group_name = var.resource_group[network.resource_group].name
        address_space = network.address_space
        dns_servers = network.dns_servers
        existing = network.existing
        tags = merge(var.var_default_tags, network.tags)
    }
  ])
}