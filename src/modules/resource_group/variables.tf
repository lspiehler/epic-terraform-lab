variable "resource_group" {
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
