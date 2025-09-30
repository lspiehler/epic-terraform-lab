resource "azurerm_backup_protected_vm" "backup_protected_vm" {
  for_each = {
    for backup in local.backups : "${backup.key}" => backup
  }
  resource_group_name = each.value.resource_group_name
  recovery_vault_name = each.value.recovery_vault_name
  source_vm_id = each.value.source_vm_id
  backup_policy_id = each.value.backup_policy_id

}