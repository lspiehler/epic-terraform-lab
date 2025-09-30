variable "recovery_vaults" {
    type = map(object({
        name = optional(string)
        resource_group = string
        location = optional(string, null)
        tags = optional(map(string), {})
        sku = optional(string, "Standard")
        public_network_access_enabled = optional(string, "true")
        storage_mode_type = optional(string, "GeoRedundant")
        cross_region_restore_enabled = optional (string, "false")
    }))
    default = {}
}

variable "vm_backup_policies" {
    type = map(object({
        name = optional(string)
        resource_group = string
        recovery_vault = string
        policy_type = optional(string, "V2")
        timezone = optional(string, "UTC")
        backup = optional(object({
            frequency = optional(string, "Daily")
            time = optional(string, "02:00")
            hour_interval = optional(string, null)
            hour_duration = optional(string, null)
            weekdays = optional(list(string), null)
        }),{})
        retention_daily = optional(object({
            count = optional(string, "14")
        }),{})
        retention_weekly = optional(object({
            count = optional(string, "8")
            weekdays = optional(list(string), ["Sunday", "Wednesday"])
        }),{})
        retention_monthly = optional(object({
            count = optional(string, "12")
            weekdays = optional(list(string), null)
            weeks = optional(list(string), null)
            days = optional(list(string), ["1"])
            include_last_days = optional(string, "false")
        }),{})
    }))
    default = {}
}

variable "fs_backup_policies" {
    type = map(object({
        name = optional(string)
        resource_group = string
        recovery_vault = string
        timezone = optional(string, "UTC")
        backup = optional(object({
            frequency = optional(string, "Daily")
            time = optional(string, "02:00")
        }),{})
        retention_daily = optional(object({
            count = optional(string, "14")
        }),{})
        retention_weekly = optional(object({
            count = optional(string, "8")
            weekdays = optional(list(string), ["Sunday", "Wednesday"])
        }),{})
        retention_monthly = optional(object({
            count = optional(string, "12")
            weekdays = optional(list(string), null)
            weeks = optional(list(string), null)
            days = optional(list(string), ["1"])
            include_last_days = optional(string, "false")
        }),{})
    }))
    default = {}
}
