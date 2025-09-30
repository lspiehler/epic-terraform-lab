locals {

  extensions = flatten([
    for vm_type_key, vms in var.var_vms : [
      for vm_key, vm in vms : [
        for vm_count, vm_index in length(vm.names) > 0 ? vm.names : range(vm.count) : [
          for extension_key, extension in vm.extension : {
            key = "${vm_index}.${extension_key}"
            name = extension.name != null ? extension.name : "${var.name_prefixes["extension"]}${extension_key}-${var.name_prefixes["vm"]}${format("${vm_key}${vm.delimeter}${vm.index_format}", vm_index)}${var.name_suffixes["vm"]}${var.name_suffixes["extension"]}"
            #name = length(vm.names) > 0 ? "${var.name_prefixes["nic"]}${nic_key}-${vm_index}${var.name_suffixes["nic"]}" : "${var.name_prefixes["nic"]}${nic_key}-${var.name_prefixes["vm"]}${format("${vm_key}${vm.delimeter}${vm.index_format}", vm_index)}${var.name_suffixes["vm"]}${var.name_suffixes["nic"]}"
            virtual_machine_id = var.mod_vms[vm_type_key]["${vm_index}"].id
            publisher = extension.publisher
            type = extension.type
            type_handler_version = extension.type_handler_version
            auto_upgrade_minor_version = extension.auto_upgrade_minor_version
            settings = extension.settings
            tags = merge(var.var_default_tags, extension.tags)
          }
        ]
      ]
    ]
  ])
}