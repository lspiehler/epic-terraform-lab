variable "container_group" {
    type = map(object({
        name = optional(string)
        resource_group = string
        location = optional(string)
        ip_address_type = optional(string, "Public")
        dns_name_label = optional(string)
        os_type = optional(string, "Linux")
        subnets = optional(list(string), [])
        exposed_port = optional(list(object({
            port = number
            protocol = optional(string, "TCP")
        })), [])
        container = map(object({
            name = optional(string)
            image = string
            cpu = optional(number, 1)
            memory = optional(number, 1)
            environment_variables = optional(map(string))
            secure_environment_variables = optional(map(string))
            ports = optional(list(object({
                port = number
                protocol = optional(string, "TCP")
            })), [])
            commands = optional(list(string))
            volume = optional(map(object({
                name = optional(string)
                mount_path = string
                storage_account = string
                share = string
                read_only = optional(bool, false)
            })), {})
        }))
        identity = optional(object({
            type = optional(string, "SystemAssigned")
            user_assigned_identities = optional(list(string))
        }), null)
        image_registry_credential = optional(list(object({
            server = string
            username = string
            password = string
        })), [])
        tags = optional(map(string))
    }))
    default = {}
}