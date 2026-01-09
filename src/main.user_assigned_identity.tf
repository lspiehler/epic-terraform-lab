module "user_assigned_identity" {
  source = "./modules/user_assigned_identity"
  var_user_assigned_identity = var.user_assigned_identity
  var_location = var.location
  mod_resource_group = module.resource_group.resource_group
  var_name_prefixes = var.name_prefixes
  var_name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}