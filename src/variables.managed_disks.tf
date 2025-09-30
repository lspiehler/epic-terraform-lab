variable "managed_disks" {
    type = map(object({
        caching = optional(string, "None")
        source_resource_id = optional(string)
        existing = optional(bool, false)
        name = optional(string)
        location = optional(string)
        resource_group = string
        zone = optional(string)
        # network_access_policy = optional(string, "DenyAll")
        # public_network_access_enabled = optional(bool, false)
        create_option = optional(string, "Empty")
        storage_account_type = optional(string, "Premium_LRS")
        tier = optional(string, null)
        disk_size_gb = optional(string, "300")
        disk_iops_read_write = optional(string, null)
        disk_mbps_read_write = optional(string, null)
        tags = optional(map(string), {})
    }))
    default = {}
}