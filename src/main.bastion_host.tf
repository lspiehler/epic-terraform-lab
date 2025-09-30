##Create all bastion hosts defined in the variable "bastion_host"
module "bastion_host" {
  source = "./modules/bastion_host"
  bastion_host = var.bastion_host
  resource_group = module.resource_group.resource_group
  subnet = module.subnet.subnet
  public_ips = module.public_ip.public_ip
  location = var.location
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}