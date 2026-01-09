variable "var_private_endpoints" {
    type = any
}

variable "mod_resource_group" {
    type = any
}

variable "mod_subnet" {
    type = any
}

variable "mod_storage_account" {
    type = any
}

variable "mod_automation_account" {
    type = any
}

variable "mod_private_dns_zone" {
    type = any
}

variable "var_name_prefixes" {
    type = map
}

variable "var_name_suffixes" {
    type = map
}

variable "var_location" {
    type = string
}

variable "var_default_tags" {
    type = map
    description = "Default tags"
}
