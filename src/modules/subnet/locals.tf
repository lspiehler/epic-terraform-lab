locals {
  subnets = flatten([
    for network_key, network in var.networks : [
      for subnet_key, subnet in network.subnets : {
        key = "${network_key}.${subnet_key}"
        name = subnet.name != null ? subnet.name : "${var.name_prefixes["subnet"]}${subnet_key}${var.name_suffixes["subnet"]}"
        resource_group_name = var.resource_group[network.resource_group].name
        virtual_network_name = var.vnet[network_key].name
        address_prefixes = subnet.address_prefixes
        service_endpoints = subnet.service_endpoints
        default_outbound_access_enabled = subnet.default_outbound_access_enabled
        private_endpoint_network_policies = subnet.private_endpoint_network_policies
        existing = subnet.existing
      }
    ]
  ])
}