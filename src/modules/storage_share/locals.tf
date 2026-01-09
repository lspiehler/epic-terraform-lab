locals {
  shares = flatten([
    for storage_account_key, storage_account in var.storage_accounts : [
      for share_key, share in storage_account.shares : {
        key = "${storage_account_key}.${share_key}"
        name = share.name != null ? share.name : "${var.name_prefixes["share"]}${share_key}${var.name_suffixes["share"]}"
        storage_account_id = var.storage_account_resources["${storage_account_key}"].id
        access_tier = share.access_tier
        enabled_protocol = share.enabled_protocol
        quota = share.quota
        existing = share.existing
      }
    ]
  ])
}