locals {

  ip_configurations = {
    for network_profile_key, network_profile in var.var_network_profile :
      "${network_profile_key}" => {
        for ip_configuration_key, ip_configuration in network_profile.container_network_interface.ip_configuration :
          "${ip_configuration_key}" => {
            name = ip_configuration.name != null ? ip_configuration.name : "${var.name_prefixes["network_profile_ipc"]}${network_profile_key}-${ip_configuration_key}${var.name_suffixes["network_profile_ipc"]}"
            subnet = var.mod_subnet[ip_configuration.subnet].id
            # application_security_group_ids = [for k, v in var.mod_application_security_group : v.id if contains(ip_configuration.application_security_groups, k)]
          }
      }
  }

  network_profiles = flatten([
    for network_profile_key, network_profile in var.var_network_profile : {
        key = "${network_profile_key}"
        location = network_profile.location != null ? network_profile.location : var.location
        name = network_profile.name != null ? network_profile.name : "${var.name_prefixes["network_profile"]}${network_profile_key}${var.name_suffixes["network_profile"]}"
        resource_group_name = var.mod_resource_group[network_profile.resource_group].name
        container_network_interface = {
          name = network_profile.container_network_interface.name != null ? network_profile.container_network_interface.name : "${var.name_prefixes["network_profile_cni"]}${network_profile_key}${var.name_suffixes["network_profile_cni"]}"
          ip_configuration = local.ip_configurations[network_profile_key]
        }
        tags = merge(var.var_default_tags, network_profile.tags)
    }
  ])
}
