variable "var_user_assigned_identity" {
    type = any
}

variable "mod_resource_group" {
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