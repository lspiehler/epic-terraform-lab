################################################
##################NAT Gateways##################
################################################

variable "nat_gateway" {
    type = map(object({
        location = optional(string, null)
        name = optional(string, null)
        resource_group = string
        sku_name = optional(string, "Standard")
        public_ips = optional(list(string), [])
        tags = optional(map(string), {})
        existing = optional(bool, false)
    }))
    default = {}
}
