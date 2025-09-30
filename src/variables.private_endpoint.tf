variable "private_endpoints" {
    type = map(object({
        name = optional(string)
        resource_group = string
        location = optional(string)
        subnet = string
        private_service_connection = object({
            name = optional(string)
            private_connection_resource_id = string
            subresource_names = optional(list(string), ["file"])
            is_manual_connection = optional(string, "false")
        })
        tags = optional(map(string))
    }))
    default = {}
}
