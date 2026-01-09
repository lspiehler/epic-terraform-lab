variable "nsgs" {
    type = map(object({
        resource_group = string
        name = optional(string)
        location = optional(string, null)
        tags = optional(map(string), {})
        existing = optional(bool, false)
        rules = optional(map(string), {})
    }))
    default = {}
}

variable "networks" {
    type = map(object({
        resource_group = string
        name = optional(string)
        peerings = optional(list(string), [])
        existing = optional(bool, false)
        address_space = optional(list(string))
        dns_servers = optional(list(string))
        location = optional(string, null)
        tags = optional(map(string), {})
        subnets = map(object({
            name = optional(string)
            existing = optional(bool, false)
            network_security_group = optional(string)
            address_prefixes = optional(list(string))
            service_endpoints = optional(list(string), null)
            default_outbound_access_enabled = optional(bool, false)
            nat_gateway = optional(string)
            private_endpoint_network_policies = optional(string, "Disabled")
            delegation = optional(object({
                name = string
                service_delegation = object({
                    name = string
                    actions = list(string)
                })
            }))
        }))
    }))
    description = "Network variables"
    default = {}
}

variable "rules" {
    type = map(object({
        #priority = 100
        direction = optional(string, "Inbound")
        access = optional(string, "Allow")
        protocol = optional(string, "Tcp")
        source_port_range = optional(string, "*")
        destination_port_range = optional(string, null)
        destination_port_ranges = optional(list(string), null)
        source_address_prefix = optional(string, null)
        source_address_prefixes = optional(list(string), null)
        destination_address_prefix = optional(string, "*")
        source_application_security_groups = optional(list(string), null)
        destination_application_security_groups = optional(list(string), null)
    }))
    default = {}
}
