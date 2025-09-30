variable "storage_accounts" {
    type = map(object({
        name = optional(string)
        location = optional(string)
        resource_group = optional(string, "sharedinfra")
        account_tier = optional(string, "Standard")
        account_kind = optional(string, "StorageV2")
        enable_https_traffic_only = optional(string)
        account_replication_type = optional(string, "LRS")
        public_network_access_enabled = optional(bool, true)
        allow_nested_items_to_be_public = optional(bool, false)
        min_tls_version = optional(string, "TLS1_2")
        tags = optional(map(string), {})
        existing = optional(bool, false)
        blob_properties = optional(object({
            delete_retention_policy = optional(object({
                days = optional(string, "14")
            }))
        }))
        azure_files_authentication = optional(object({
            directory_type = optional(string)
            active_directory = optional(object({
                domain_guid = optional(string)
                domain_name = optional(string)
                domain_sid = optional(string)
                forest_name = optional(string)
                netbios_domain_name = optional(string)
                storage_sid = optional(string)
            }))
        }))
        network_rules = optional(object({
            default_action = optional(string, "Deny")
            ip_rules = optional(list(string))
            virtual_network_subnets = optional(list(string))
            bypass = optional(list(string), ["AzureServices"])
        }))
        shares = optional(map(object({
            name = optional(string)
            access_tier = optional(string)
            enabled_protocol = optional(string)
            quota = optional(string, "10")
        })),{})
        sas_policy = optional(object({
            expiration_period = optional(string, "02.00:00:00")
        }),{})
    }))
    default = {}
}
