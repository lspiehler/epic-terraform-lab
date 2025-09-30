locals {
  nat_gateway_ips = flatten([
    for nat_gateway_key, nat_gateway in var.nat_gateway : [
      for public_ip in nat_gateway.public_ips : {
        key = "${nat_gateway_key}.${public_ip}"
        nat_gateway_id = var.mod_nat_gateway[nat_gateway_key].id
        public_ip_address_id = var.mod_public_ip[public_ip].id
      }
    ] if length(nat_gateway.public_ips) > 0
  ])
}