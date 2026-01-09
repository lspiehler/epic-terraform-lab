variable "private_endpoints" {
    type = map(object({
        name = optional(string)
        resource_group = string
        location = optional(string)
        subnet = string
        private_service_connection = object({
            name = optional(string)
            private_connection_resource_type = string
            private_connection_resource = string
            subresource_names = optional(list(string), [])
            is_manual_connection = optional(bool, false)
        })
        private_dns_zone_group = optional(object({
            name = optional(string)
            private_dns_zones = optional(list(string), [])
        }))
        tags = optional(map(string))
    }))
    default = {}
}
