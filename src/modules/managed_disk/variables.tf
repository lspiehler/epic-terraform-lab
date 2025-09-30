variable "vms" {
    type = object({
      windows = map(any)
      linux = map(any)
    })
}

variable "mod_vms" {
    type = object({
      windows = map(any)
      linux = map(any)
    })
}

variable "var_managed_disks" {
    type = map
}

variable "resource_group" {
    type = map
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
