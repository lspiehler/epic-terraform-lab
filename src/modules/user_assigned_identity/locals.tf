locals {
 user_assigned_identity = flatten([
    for uai_key, uai in var.var_user_assigned_identity : {
        key = "${uai_key}"
        name = uai.name != null ? uai.name : "${var.var_name_prefixes["user_assigned_identity"]}${uai_key}${var.var_name_suffixes["user_assigned_identity"]}"
        location = uai.location != null ? uai.location : var.var_location
        resource_group_name = var.mod_resource_group[uai.resource_group].name
        existing = uai.existing
        management_lock = uai.management_lock
        tags = merge(var.var_default_tags, uai.tags)
    }
  ])
}