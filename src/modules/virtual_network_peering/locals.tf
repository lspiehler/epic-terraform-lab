locals {
  peerings = flatten([
    for network_key, network in var.networks : [
      for peering_index, peering in network.peerings : {
        key = "${network_key}.${peering}"
        name = "${var.name_prefixes["peering"]}${var.name_prefixes["vnet"]}${peering}-${network_key}${var.name_suffixes["vnet"]}${var.name_suffixes["peering"]}"
        resource_group_name = var.resource_group[network.resource_group].name
        virtual_network_name = var.vnet[network_key].name
        remote_virtual_network_id = var.vnet[peering].id
      }
    ]
  ])
}