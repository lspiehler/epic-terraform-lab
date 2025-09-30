variable "var_vms" {
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

variable "var_default_tags" {
    type = map
    description = "Default tags"
    default = {}
}

variable "name_prefixes" {
    type = map
}

variable "name_suffixes" {
    type = map
}