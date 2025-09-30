##Create all public_ips defined in the variable "public_ips"
module "storage_account" {
  source = "./modules/storage_account"
  storage_accounts = var.storage_accounts
  resource_group = module.resource_group.resource_group
  subnet = module.subnet.subnet
  location = var.location
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}

module "storage_share" {
  source = "./modules/storage_share"
  storage_accounts = var.storage_accounts
  storage_account_resources = module.storage_account.resource
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
}

##Create all public_ips defined in the variable "public_ips"
/*module "storage_account_network_rules" {
  source = "./modules/network_rules"
  storage_accounts = var.storage_accounts
  storage_account_resources = module.storage_account.resource
  subnet = module.subnet.subnet
  location = var.location
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
}*/