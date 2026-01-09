################################################
###############Resource Groups##################
################################################

variable "network_profile" {
    type = map(object({
        name = optional(string, null)
        location = optional(string, null)
        resource_group = string
        container_network_interface = object({
            name = string
            ip_configuration = map(object({
                name = optional(string, null)
                subnet = string
                # application_security_groups = optional(list(string), [])
            }))
        })
        tags = optional(map(string), {})
    }))
    default = {}
}
