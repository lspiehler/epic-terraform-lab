resource "azurerm_backup_policy_file_share" "backup_policy_file_share" {
  for_each = {
    for policy in local.policies : "${policy.key}" => policy
  }
  name = each.value.name
  resource_group_name = each.value.resource_group_name
  recovery_vault_name = each.value.recovery_vault_name
  timezone = each.value.timezone
  retention_daily {
    count = each.value.retention_daily.count
  }
  retention_weekly {
    count = each.value.retention_weekly.count
    weekdays = each.value.retention_weekly.weekdays
  }
  retention_monthly {
    count = each.value.retention_monthly.count
    weekdays = each.value.retention_monthly.weekdays
    weeks = each.value.retention_monthly.weeks
    days = each.value.retention_monthly.days
    include_last_days = each.value.retention_monthly.include_last_days
  }
  backup {
    frequency = each.value.backup.frequency
    time = each.value.backup.time
  }
}