locals {
  nat_gateway_attachments = flatten([
    for network_key, network in var.networks : [
      for subnet_key, subnet in network.subnets : {
        key = "${network_key}.${subnet_key}.${subnet.nat_gateway}"
        nat_gateway = var.mod_nat_gateway[subnet.nat_gateway].id
        subnet = var.mod_subnet["${network_key}.${subnet_key}"].id
      } if subnet.nat_gateway != null
    ]
  ])
}