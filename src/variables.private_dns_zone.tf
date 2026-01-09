variable "private_dns_zones" {
    type = map(object({
        name = optional(string)
        existing = optional(bool, false)
        resource_group = string
        tags = optional(map(string))
    }))
    default = {}
}
