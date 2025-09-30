variable "vms" {
    type = any
}

variable "resource_group" {
    type = any
}

variable "subnet" {
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

variable "var_default_tags" {
    type = map
    description = "Default tags"
}
