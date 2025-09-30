locals {
 public_ips = flatten([
    for public_ip_key, public_ip in var.public_ips : {
        key = "${public_ip_key}"
        name = public_ip.name != null ? public_ip.name : "${var.name_prefixes["public_ip"]}${public_ip_key}${var.name_suffixes["public_ip"]}"
        location = public_ip.location != null ? public_ip.location : var.location
        resource_group_name = var.resource_group[public_ip.resource_group].name
        allocation_method = public_ip.allocation_method
        existing = public_ip.existing
        management_lock = public_ip.management_lock
        tags = merge(var.var_default_tags, public_ip.tags)
    }
  ])
}