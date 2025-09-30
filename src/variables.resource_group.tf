################################################
###############Resource Groups##################
################################################

variable "rgs" {
    type = map(object({
        location = optional(string, null)
        name = optional(string, null)
        tags = optional(map(string), {})
        existing = optional(bool, false)
    }))
    default = {}
}
