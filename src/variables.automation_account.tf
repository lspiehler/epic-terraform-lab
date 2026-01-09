################################################
###############Resource Groups##################
################################################

variable "automation_account" {
    type = map(object({
        name = optional(string)
        location = optional(string)
        resource_group = string
        sku_name = optional(string, "Basic") // Basic or Free
        identity = optional(object({
            type = optional(string, null)
        }))
        local_authentication_enabled = optional(bool, true)
        public_network_access_enabled = optional(bool, true)
        tags = optional(map(string), {})
    }))
    default = {}
}
