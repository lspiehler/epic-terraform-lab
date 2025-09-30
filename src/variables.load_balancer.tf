variable "load_balancer" {
    type = map(object({
        name = optional(string)
        existing = optional(bool, false)
        location = optional(string)
        resource_group = optional(string)
        
        frontend_ip_configuration = optional(map(object({
            name = optional(string)
            public_ip_address = optional(string)
            subnet = optional(string)
            private_ip_address = optional(string)
            private_ip_address_allocation = optional(string, null)
            private_ip_address_version = optional(string, null)
        })), {})

        rules = optional(map(object({
            name = optional(string)
            protocol = optional(string, "Tcp")
            probe = optional(string)
            disable_outbound_snat = optional(bool, true)
            load_distribution = optional(string, "Default")
            frontend_port = optional(number)
            backend_port = optional(number)
            idle_timeout_in_minutes = optional(number, 4)
            frontend_ip_configuration_name = optional(string)
            backend_address_pools = optional(list(string))
            enable_floating_ip = optional(bool, false)
        })), {})

        outbound_rules = optional(map(object({
            name = optional(string)
            protocol = optional(string, "All")
            backend_address_pool = optional(string)
            enable_tcp_reset = optional(bool, true)
            idle_timeout_in_minutes = optional(number, 4)
            allocated_outbound_ports = optional(number, 1024)
            frontend_ip_configuration = optional(list(object({
                name = string
            })), [])
        })), {})

        nat_rules = optional(map(object({
            name = optional(string)
            protocol = optional(string, "Tcp")
            frontend_port_start = optional(number)
            frontend_port_end = optional(number)
            backend_port = optional(number)
            backend_address_pool = optional(string)
            frontend_ip_configuration_name = optional(string)
        })), {})

        probes = optional(map(object({
            name = optional(string)
            protocol = optional(string)
            request_path = optional(string)
            port = optional(number)
            number_of_probes = optional(number, 1)
            interval_in_seconds = optional(number, 5)
        })), {})

        backend_address_pool = optional(map(object({
            name = optional(string)
            target = optional(object({
                vm_tag = object({
                    key = string
                    value = string
                })
                nic = string
            }))
        })), {})

        tags = optional(map(string), null)
    }))
    default = {}
}