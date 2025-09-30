locals {

  subnets = {
    for storage_account_key, storage_account in var.storage_accounts : 
      "${storage_account_key}" => {
          for subnet in storage_account.network_rules.virtual_network_subnets :
            "subnets" => var.subnet[subnet].id...
      }
  }

  networkrules = flatten([
    for storage_account_key, storage_account in var.storage_accounts : {
      storage_account_id = var.storage_account_resources[storage_account_key].id

      default_action             = storage_account.network_rules.default_action
      ip_rules                   = storage_account.network_rules.ip_rules
      virtual_network_subnet_ids = local.subnets[storage_account_key].subnets
      bypass                     = storage_account.network_rules.bypass
    }
  ])
}
