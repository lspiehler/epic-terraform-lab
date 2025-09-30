locals {
  associations = flatten([
    for network_key, network in var.networks : [
      for subnet_key, subnet in network.subnets : {
        key = "${network_key}.${subnet_key}.${subnet.network_security_group}"
        subnet_id = var.subnet["${network_key}.${subnet_key}"].id
        network_security_group_id = var.nsg[subnet.network_security_group].id
      } if subnet.network_security_group != null
    ]
  ])
}