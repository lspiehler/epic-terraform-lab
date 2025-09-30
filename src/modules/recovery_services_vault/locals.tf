locals {
 vaults = flatten([
    for vault_key, vault in var.recovery_vaults : {
        key = "${vault_key}"
        name = vault.name != null ? vault.name : "${var.name_prefixes["vault"]}${vault_key}${var.name_suffixes["vault"]}"
        location = vault.location != null ? vault.location : var.location
        resource_group_name = var.resource_group[vault.resource_group].name
        sku = vault.sku
        public_network_access_enabled = vault.public_network_access_enabled
        storage_mode_type = vault.storage_mode_type
        cross_region_restore_enabled = vault.cross_region_restore_enabled
        tags = merge(var.var_default_tags, vault.tags)
    }
  ])
}