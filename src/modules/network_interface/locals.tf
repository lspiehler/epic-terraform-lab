locals {

  # if only one ip_config is defined in a VM block, then ip_config_index will be 0 so that the only defined ip_config is used
  ip_config_index = {
    for vm_type_key, vms in var.vms :
      "${vm_type_key}" => {
        for vm_key, vm in vms :
          "${vm_key}" => {
            for vm_count, vm_index in length(vm.names) > 0 ? vm.names : range(vm.count) :
              "${vm_count}" => {
                for nic_key, nic in vm.nics :
                  "${nic_key}" => length(nic.ip_configuration) > 1 ? vm_count : 0
              }
          }
      }
  }

  # restructure ip_configs to be used in the azurerm_network_interface resource
  ip_configs = {
    for vm_type_key, vms in var.vms :
      "${vm_type_key}" => {
        for vm_key, vm in vms :
          "${vm_key}" => {
            for vm_count, vm_index in length(vm.names) > 0 ? vm.names : range(vm.count) :
              "${vm_count}" => {
                for nic_key, nic in vm.nics :
                  "${nic_key}" => flatten([
                    for ip_configs_count, ip_config in nic.ip_configuration[local.ip_config_index["${vm_type_key}"]["${vm_key}"]["${vm_count}"]["${nic_key}"]] : {
                        name = length(vm.names) > 0 ? "${var.name_prefixes["ip"]}${vm_index}${var.name_suffixes["ip"]}${vm.delimeter}${ip_configs_count + 1}" : "${var.name_prefixes["ip"]}${format("${vm_key}${vm.delimeter}${vm.index_format}", vm_index)}${var.name_suffixes["ip"]}${vm.delimeter}${ip_configs_count + 1}"
                        subnet_id = var.subnet[ip_config.subnet].id
                        primary = ip_config.primary
                        private_ip_address_allocation = ip_config.private_ip_address_allocation
                        private_ip_address = ip_config.private_ip_address
                    }
                  ])
              }
          }
      }
  }
  
  nics = flatten([
    for vm_type_key, vms in var.vms : [
      for vm_key, vm in vms : [
        for vm_count, vm_index in length(vm.names) > 0 ? vm.names : range(vm.count) : [
          for nic_key, nic in vm.nics : {
            count = vm.count
            key = "${vm_index}.${nic_key}"
            name = length(vm.names) > 0 ? "${var.name_prefixes["nic"]}${nic_key}-${vm_index}${var.name_suffixes["nic"]}" : "${var.name_prefixes["nic"]}${nic_key}-${var.name_prefixes["vm"]}${format("${vm_key}${vm.delimeter}${vm.index_format}", vm_index)}${var.name_suffixes["vm"]}${var.name_suffixes["nic"]}"
            location = vm.location != null ? vm.location : var.location
            resource_group_name = var.resource_group[vm.resource_group].name
            accelerated_networking_enabled = nic.accelerated_networking_enabled
            ip_forwarding_enabled = nic.ip_forwarding_enabled
            # ip_configuration = {
            #   name = length(vm.names) > 0 ? "${var.name_prefixes["ip"]}${vm_index}${var.name_suffixes["ip"]}${vm.delimeter}1" : "${var.name_prefixes["ip"]}${format("${vm_key}${vm.delimeter}${vm.index_format}", vm_index)}${var.name_suffixes["ip"]}${vm.delimeter}1"
            #   subnet_id = var.subnet[nic.ip_configuration[0][0].subnet].id
            #   private_ip_address_allocation = nic.ip_configuration[0][0].private_ip_address_allocation
            # }
            ip_configuration = local.ip_configs["${vm_type_key}"]["${vm_key}"]["${vm_count}"]["${nic_key}"]
            tags = merge(var.var_default_tags, nic.tags)
          }
        ]
      ]
    ]
  ])
}

# output "ip_configs" {
#   value = local.ip_configs
# }

# output "ip_config_index" {
#   value = local.ip_config_index
# }