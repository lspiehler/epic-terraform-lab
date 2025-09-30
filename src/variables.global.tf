################################################
##############Location and Time#################
################################################

variable "location" {
    type = string
    description = "Primary Azure region to build in"
}

variable "timezone" {
    type = string
    description = "OS Timezone"
    default = null
}

variable "name_prefixes" {
    type = map
    description = "Prefixes for resource types"
}

variable "name_suffixes" {
    type = map
    description = "Suffixes for resource types"
}

variable "subscription_id" {
    type = string
    description = "Azure subscription ID"
}

variable "default_tags" {
    type = map
    description = "Default tags for all resources"
    default = {}
}
