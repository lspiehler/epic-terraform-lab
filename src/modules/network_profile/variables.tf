variable "mod_resource_group" {
    type = any
}

variable "var_network_profile" {
    type = map
}

variable "mod_application_security_group" {
    type = any
}

variable "mod_subnet" {
    type = any
}

variable "location" {
    type = string
}

variable "name_prefixes" {
    type = map
}

variable "name_suffixes" {
    type = map
}

variable "var_default_tags" {
    type = map
    description = "Default tags"
}
