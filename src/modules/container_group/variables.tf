variable "var_container_group" {
    type = map
}

variable "mod_resource_group" {
    type = any
}

variable "mod_user_assigned_identity" {
    type = any
}

variable "mod_storage_account" {
    type = any
}

variable "mod_subnet" {
    type = any
}

variable "mod_storage_share" {
    type = any
}

variable "var_location" {
    type = string
}

variable "var_name_prefixes" {
    type = map
}

variable "var_name_suffixes" {
    type = map
}

variable "var_default_tags" {
    type = map
    description = "Default tags"
}