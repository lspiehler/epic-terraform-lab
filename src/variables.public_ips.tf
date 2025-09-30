variable "public_ips" {
    type = map(object({
        name = optional(string)
        existing = optional(bool, false)
        location = optional(string)
        resource_group = optional(string)
        allocation_method = optional(string, "Static")
        tags = optional(map(string), {})
        management_lock = optional(object({
            name = optional(string)
            lock_level = optional(string, "CanNotDelete")
            notes      = optional(string)
        }))
    }))
    default = {}
}
