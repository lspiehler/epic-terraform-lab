variable "networks" {
    type = any
}

variable "mod_subnet" {
    type = map
}

variable "mod_nat_gateway" {
    type = map
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