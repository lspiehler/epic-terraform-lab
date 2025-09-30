module "resource_group" {
  source = "./modules/resource_group"
  resource_group = var.rgs
  location = var.location
  name_prefixes = var.name_prefixes
  name_suffixes = var.name_suffixes
  var_default_tags = var.default_tags
}
