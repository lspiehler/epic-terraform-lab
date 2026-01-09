locals {
  automation_accounts = flatten([
    for automation_account_key, automation_account in var.var_automation_account : {
        key = "${automation_account_key}"
        location = automation_account.location != null ? automation_account.location : var.location
        name = automation_account.name != null ? automation_account.name : "${var.name_prefixes["automation_account"]}${automation_account_key}${var.name_suffixes["automation_account"]}"
        resource_group_name = var.mod_resource_group[automation_account.resource_group].name
        sku_name = automation_account.sku_name
        identity = automation_account.identity
        local_authentication_enabled = automation_account.local_authentication_enabled
        public_network_access_enabled = automation_account.public_network_access_enabled
        tags = merge(var.var_default_tags, automation_account.tags)
    }
  ])
}