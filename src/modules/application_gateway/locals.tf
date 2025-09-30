locals {
    /*auto_backend_http_settings = flatten([
        for agw_key, agw in var.agws : [
            for auto_configure_app_key, auto_configure_app in agw.auto_configure_apps : {
                name = "backend_https_${auto_configure_app_key}"
                cookie_based_affinity = "Enabled"
                //path = "/path1/"
                host_name = auto_configure_app.internal_host
                port = 443
                protocol = "Https"
                request_timeout = 60
                probe_name = "probe_https"
                trusted_root_certificate_names = "default_root"
            }
        ]
    ])

    auto_backend_address_pool = flatten([
        for agw_key, agw in var.agws : [
            for auto_configure_app_key, auto_configure_app in agw.auto_configure_apps : {
                name = "backend_address_${auto_configure_app_key}"
                vms = {
                    vm_keys = [auto_configure_app_key]
                }
            }
        ]
    ])

    auto_agw_backend_ips = {
        for agw_key, agw in var.agws : "${agw_key}" => {
            for beap_key, beap in agw.backend_address_pool : "${beap_key}" => flatten([
                for vm_key, vm in merge(var.vms.linux, var.vms.windows) : [
                    for vm_count, vm_index in length(vm.names) > 0 ? vm.names : range(vm.count) : [
                        for nic_key, nic in vm.nics : [
                            for ip_configuration_key, ip_configuration in var.nic["${vm_key}.${vm_index}.${nic_key}"].ip_configuration : [
                                ip_configuration.private_ip_address
                                #nic_names = var.nic["${vm_key}.${vm_index}.${nic_key}"].name
                            ]
                        ]
                    ] if contains(beap.vms.exclude, vm_index) == false
                ] if contains(beap.vms.vm_keys, vm_key)
            ]) if beap.vms != null
        }
    }*/

    agw_backend_ips = {
        for agw_key, agw in var.agws : "${agw_key}" => {
            for beap_key, beap in agw.backend_address_pool : "${beap_key}" => flatten([
                for vm_key, vm in merge(var.vms.linux, var.vms.windows) : [
                    for vm_count, vm_index in length(vm.names) > 0 ? vm.names : range(vm.count) : [
                        for nic_key, nic in vm.nics : [
                            for ip_configuration_key, ip_configuration in var.nic["${vm_index}.${nic_key}"].ip_configuration : [
                                ip_configuration.private_ip_address
                                #nic_names = var.nic["${vm_key}.${vm_index}.${nic_key}"].name
                            ]
                        ]
                    ] if vm.tags[beap.target.vm_tag.key] == beap.target.vm_tag.value
                ] if contains(keys(vm.tags), beap.target.vm_tag.key) == true
            ]) if beap.target != null
        }
    }

}

/*output "ip_object" {
    value = local.auto_backend_address_pool
}*/