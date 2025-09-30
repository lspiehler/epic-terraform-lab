variable "bastion_host" {
    type = map(object({
        resource_group = string
        location = optional(string)
        ip_configuration = object({
            subnet = string
            public_ip_address = string
        })
        tunneling_enabled = optional(bool, true)
        sku = optional(string, "Standard")
        tags = optional(map(string))
    }))
    default = {}
}
