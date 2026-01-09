locals {
  asgs = flatten([
    for asg_key, asg in var.var_application_security_group : {
        key = "${asg_key}"
        location = asg.location != null ? asg.location : var.location
        name = asg.name != null ? asg.name : "${var.name_prefixes["application_security_group"]}${asg_key}${var.name_suffixes["application_security_group"]}"
        resource_group_name = var.mod_resource_group[asg.resource_group].name
        tags = merge(var.var_default_tags, asg.tags)
        existing = asg.existing
    }
  ])
}