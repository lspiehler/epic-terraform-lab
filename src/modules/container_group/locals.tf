locals {

  container_groups = flatten([
    for cg_key, cg in var.var_container_group : {
      key = "${cg_key}"
      name = cg.name != null ? cg.name : "${var.var_name_prefixes["container_group"]}${cg_key}${var.var_name_suffixes["container_group"]}"
      resource_group_name = var.mod_resource_group[cg.resource_group].name
      location = cg.location != null ? cg.location : var.var_location
      ip_address_type = cg.ip_address_type
      dns_name_label = cg.dns_name_label
      os_type = cg.os_type
      exposed_port = cg.exposed_port
      container = cg.container
      # subnet_ids = local.subnets[cg_key].subnets
      // if UserAssigned identity is used, get the user assigned identity IDs
      identity = cg.identity != null && cg.identity.type == "UserAssigned" ? {
        type = cg.identity.type
        identity_ids = [for k, v in var.mod_user_assigned_identity : v.id if contains(cg.identity.user_assigned_identities, k)]
      } : {
        type = cg.identity.type
        identity_ids = null
      }
      subnet_ids = [for k, v in var.mod_subnet : v.id if contains(cg.subnets, k)]
      image_registry_credential = cg.image_registry_credential
      tags = merge(var.var_default_tags, cg.tags)
    }
  ])
}
