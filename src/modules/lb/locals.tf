locals {

    load_balancers = flatten([
        for load_balancer_key, load_balancer in var.load_balancers : {
            key = "${load_balancer_key}"
            name = load_balancer.name != null ? load_balancer.name : "${var.name_prefixes["lb"]}${load_balancer_key}${var.name_suffixes["lb"]}"
            location = load_balancer.location != null ? load_balancer.location : var.location
            resource_group_name = var.resource_group[load_balancer.resource_group].name
            frontend_ip_configuration = load_balancer.frontend_ip_configuration
            #backend_address_pool = load_balancer.backend_address_pool
            #nat_rule = load_balancer.nat_rule
            tags = load_balancer.tags != null ? load_balancer.tags : {
                Terraform = "Yes"
                Application = load_balancer_key
            }
        }
    ])

    /*frontend_ip_configurations = flatten([
        for load_balancer_key, load_balancer in var.load_balancers : [
            for feipc_key, feipc in load_balancer : {
                name = feipc.name != null ? feipc.name : feipc_key
                public_ip_address_id = var.public_ips[feipc.public_ip_address].id
            }
        ]
    ])*/

    nat_rules = flatten([
        for load_balancer_key, load_balancer in var.load_balancers : [
            for nat_rule_key, nat_rule in load_balancer.nat_rules : {
                key = "${load_balancer_key}.${nat_rule_key}"
                name = nat_rule.name != null ? nat_rule.name : nat_rule_key
                resource_group_name = var.resource_group[load_balancer.resource_group].name
                load_balancer = load_balancer_key
                protocol = nat_rule.protocol
                frontend_port_start = nat_rule.frontend_port_start
                frontend_port_end = nat_rule.frontend_port_end
                backend_port = nat_rule.backend_port
                frontend_ip_configuration_name = nat_rule.frontend_ip_configuration_name
                backend_address_pool = "${load_balancer_key}.${nat_rule.backend_address_pool}"
            }
        ]
    ])

    probes = flatten([
        for load_balancer_key, load_balancer in var.load_balancers : [
            for probe_key, probe in load_balancer.probes : {
                key = "${load_balancer_key}.${probe_key}"
                name = probe.name != null ? probe.name : probe_key
                load_balancer = load_balancer_key
                protocol = probe.protocol
                port = probe.port
                number_of_probes = probe.number_of_probes
                request_path = probe.request_path
                interval_in_seconds = probe.interval_in_seconds
            }
        ]
    ])

    rules = flatten([
        for load_balancer_key, load_balancer in var.load_balancers : [
            for rule_key, rule in load_balancer.rules : {
                key = "${load_balancer_key}.${rule_key}"
                name = rule.name != null ? rule.name : rule_key
                load_balancer = load_balancer_key
                protocol = rule.protocol
                disable_outbound_snat = rule.disable_outbound_snat
                probe = rule.probe
                frontend_port = rule.frontend_port
                backend_port = rule.backend_port
                idle_timeout_in_minutes = rule.idle_timeout_in_minutes
                frontend_ip_configuration_name = rule.frontend_ip_configuration_name
                load_distribution = rule.load_distribution
                backend_address_pools = rule.backend_address_pools
                enable_floating_ip = rule.enable_floating_ip
            }
        ]
    ])

    outbound_rules = flatten([
        for load_balancer_key, load_balancer in var.load_balancers : [
            for outbound_rule_key, outbound_rule in load_balancer.outbound_rules : {
                key = "${load_balancer_key}.${outbound_rule_key}"
                name = outbound_rule.name != null ? outbound_rule.name : outbound_rule_key
                load_balancer = load_balancer_key
                protocol = outbound_rule.protocol
                allocated_outbound_ports = outbound_rule.allocated_outbound_ports
                idle_timeout_in_minutes = outbound_rule.idle_timeout_in_minutes
                enable_tcp_reset = outbound_rule.enable_tcp_reset
                frontend_ip_configuration = outbound_rule.frontend_ip_configuration
                backend_address_pool = "${load_balancer_key}.${outbound_rule.backend_address_pool}"
            }
        ]
    ])

    backend_address_pools = flatten([
        for load_balancer_key, load_balancer in var.load_balancers : [
            for beap_key, beap in load_balancer.backend_address_pool : {
                key = "${load_balancer_key}.${beap_key}"
                name = beap.name != null ? beap.name : beap_key
                load_balancer = load_balancer_key
            }
        ]
    ])

    load_balancer_backend_ips = flatten([
        for load_balancer_key, load_balancer in var.load_balancers : [
            for beap_key, beap in load_balancer.backend_address_pool : [
                for vm_key, vm in merge(var.vms.linux, var.vms.windows) : [
                    for vm_count, vm_index in length(vm.names) > 0 ? vm.names : range(vm.count) : [
                        for nic_key, nic in vm.nics : [
                            for ip_configuration_key, ip_configuration in var.nic["${vm_index}.${nic_key}"].ip_configuration : {
                                key = "${load_balancer_key}-${beap_key}-${ip_configuration.name}"
                                ip_configuration_name = ip_configuration.name
                                network_interface_id = var.nic["${vm_index}.${nic_key}"].id
                                backend_address_pool = "${load_balancer_key}.${beap_key}"
                                #virtual_network_id = var.vnet[beap.vms.virtual_network].id
                                #nic_names = var.nic["${vm_index}.${nic_key}"].name
                            }
                        ] if nic_key == beap.target.nic
                    ] if vm.tags[beap.target.vm_tag.key] == beap.target.vm_tag.value
                ] if contains(keys(vm.tags), beap.target.vm_tag.key) == true
            ] if beap.target != null
        ]
    ])

}

/*output "test" {
    value = local.load_balancer_backend_ips
}*/