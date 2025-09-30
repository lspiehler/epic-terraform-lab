variable "load_balancers" {
    type = any
}

variable "resource_group" {
    type = any
}

variable "subnet" {
    type = any
}

variable "public_ips" {
    type = any
}

variable "nic" {
    type = any
}

variable "vms" {
    type = any
}

variable "vm_resources" {
    type = any
}

variable "vnet" {
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
