variable "linux" {
    type = any
}

variable "mod_orchestrated_virtual_machine_scale_set" {
    type = map
}

variable "resource_group" {
    type = any
}

variable "storage_accounts" {
    type = any
}

variable "nic" {
    type = any
}

variable "name_prefixes" {
    type = map
}

variable "name_suffixes" {
    type = map
}

variable "location" {
    type = string
}

variable "secrets" {
    type = map(string)
}

variable "var_default_tags" {
    type = map
    description = "Default tags"
}
