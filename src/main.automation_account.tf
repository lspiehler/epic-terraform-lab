module "automation_account" {
  source = "./modules/automation_account"
  var_automation_account = var.automation_account
  mod_resource_group = module.resource_group.resource_group
  location = var.location
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}
