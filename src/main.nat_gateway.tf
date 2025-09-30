module "nat_gateway" {
  source = "./modules/nat_gateway"
  nat_gateway = var.nat_gateway
  mod_resource_group = module.resource_group.resource_group
  location = var.location
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}

module "nat_gateway_attachments" {
  source = "./modules/nat_gateway_attachment"
  networks = var.networks
  mod_subnet = module.subnet.subnet
  mod_nat_gateway = module.nat_gateway.nat_gateway
  location = var.location
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
}

module "nat_gateway_public_ip_association" {
  source = "./modules/nat_gateway_public_ip_association"
  nat_gateway = var.nat_gateway
  mod_nat_gateway = module.nat_gateway.nat_gateway
  mod_public_ip = module.public_ip.public_ip
}
