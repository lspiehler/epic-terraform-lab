locals {
 policies = flatten([
    for policy_key, policy in var.fs_backup_policies : {
        key = "${policy_key}"
        name = policy.name != null ? policy.name : "${var.name_prefixes["backup_pol"]}${policy_key}${var.name_suffixes["backup_pol"]}"
        resource_group_name = var.resource_group[policy.resource_group].name
        recovery_vault_name = var.vault_resources[policy.recovery_vault].name
        timezone = var.var_timezone != null ? var.var_timezone : policy.timezone
        backup = policy.backup
        retention_daily = policy.retention_daily
        retention_weekly = policy.retention_weekly
        retention_monthly = policy.retention_monthly
    }
  ])
}