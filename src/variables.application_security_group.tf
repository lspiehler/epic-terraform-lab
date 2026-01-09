################################################
###############Resource Groups##################
################################################

variable "application_security_group" {
    type = map(object({
        name = optional(string, null)
        location = optional(string, null)
        resource_group = string
        tags = optional(map(string), {})
        existing = optional(bool, false)
    }))
    default = {}
}
