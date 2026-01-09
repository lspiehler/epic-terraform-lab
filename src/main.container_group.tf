module "container_group" {
  source = "./modules/container_group"
  var_container_group = var.container_group
  mod_resource_group = module.resource_group.resource_group
  mod_user_assigned_identity = module.user_assigned_identity.user_assigned_identity
  mod_storage_account = module.storage_account.resource
  mod_storage_share = module.storage_share.storage_share
  var_location = var.location
  mod_subnet = module.subnet.subnet
  var_name_prefixes = var.name_prefixes
  var_name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}
