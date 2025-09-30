locals {
  rules = flatten([
    for nsg_var_key, nsg_var in var.nsg_vars : [
      for rule_key, rule in nsg_var.rules : {
        key = "${nsg_var_key}.${rule_key}"
        name                        = rule_key
        priority                    = rule
        direction                   = var.rules[rule_key].direction
        access                      = var.rules[rule_key].access
        protocol                    = var.rules[rule_key].protocol
        source_port_range           = var.rules[rule_key].source_port_range
        destination_port_range      = var.rules[rule_key].destination_port_ranges == null ? var.rules[rule_key].destination_port_range: null
        destination_port_ranges     = var.rules[rule_key].destination_port_ranges
        source_address_prefix       = var.rules[rule_key].source_address_prefixes == null ? var.rules[rule_key].source_address_prefix : null
        source_address_prefixes     = var.rules[rule_key].source_address_prefixes
        destination_address_prefix  = var.rules[rule_key].destination_address_prefix
        resource_group_name         = var.resource_group[nsg_var.resource_group].name
        network_security_group_name = var.nsg[nsg_var_key].name
      }
    ]
  ])
}