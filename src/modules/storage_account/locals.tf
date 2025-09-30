locals {

  subnets = {
    for storage_account_key, storage_account in var.storage_accounts : 
      "${storage_account_key}" => {
          for subnet in storage_account.network_rules.virtual_network_subnets :
            "subnets" => var.subnet[subnet].id...
      } if storage_account.network_rules != null
  }

  storageaccounts = flatten([
    for storage_account_key, storage_account in var.storage_accounts : {
        key = "${storage_account_key}"
        name = storage_account.name != null ? storage_account.name : "${var.name_prefixes["storage_account"]}${storage_account_key}${var.name_suffixes["storage_account"]}"
        location = storage_account.location != null ? storage_account.location : var.location
        resource_group_name = var.resource_group[storage_account.resource_group].name
        account_tier = storage_account.account_tier
        account_kind = storage_account.account_kind
        public_network_access_enabled = storage_account.public_network_access_enabled
        allow_nested_items_to_be_public = storage_account.allow_nested_items_to_be_public
        min_tls_version = storage_account.min_tls_version
        account_replication_type = storage_account.account_replication_type
        network_rules = storage_account.network_rules
        existing = storage_account.existing
        sas_policy = {
          expiration_period = storage_account.sas_policy.expiration_period
        }
        blob_properties = storage_account.blob_properties
        azure_files_authentication = storage_account.azure_files_authentication
        tags = merge(var.var_default_tags, storage_account.tags)
        /*network_rules = storage_account.network_rules == null ? null : {
          default_action = "deny"
          ip_rules = storage_account.network_rules.ip_rules
          virtual_network_subnet_ids = var.subnet[storage_account.network_rules.subnet].id
        }*/
    }
  ])
}
