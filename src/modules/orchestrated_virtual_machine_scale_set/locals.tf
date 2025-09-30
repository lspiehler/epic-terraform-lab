locals {
 vm_scale_sets = flatten([
    for vmss_key, vmss in var.var_vmss : {
        key = "${vmss_key}"
        name = vmss.name != null ? vmss.name : "${var.var_name_prefixes["vmss"]}${vmss_key}${var.var_name_suffixes["vmss"]}"
        location = vmss.location != null ? vmss.location : var.var_location
        resource_group_name = var.mod_resource_group[vmss.resource_group].name
        existing = vmss.existing
        zones = vmss.zones
        encryption_at_host_enabled = vmss.encryption_at_host_enabled
        single_placement_group = vmss.single_placement_group
        platform_fault_domain_count = vmss.platform_fault_domain_count
        tags = merge(var.var_default_tags, vmss.tags)
    }
  ])
}