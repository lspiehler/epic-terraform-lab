resource "azurerm_storage_account" "storage_accounts" {
  for_each = {
    for storage_account in local.storageaccounts : "${storage_account.key}" => storage_account if storage_account.existing == false
  }
  name = each.value.name
  #checkov:skip=CKV2_AZURE_31:Checkov is falsely reporting that the subnet is not associated with a network security group
  #checkov:skip=CKV2_AZURE_1:Using Microsoft Managed Keys
  #checkov:skip=CKV_AZURE_206:For non-production we are ok not using replication
  
  resource_group_name = each.value.resource_group_name
  location = each.value.location
  account_tier = each.value.account_tier
  account_kind = each.value.account_kind
  public_network_access_enabled = each.value.public_network_access_enabled
  allow_nested_items_to_be_public = each.value.allow_nested_items_to_be_public
  min_tls_version = each.value.min_tls_version
  account_replication_type = each.value.account_replication_type
  tags = each.value.tags

  sas_policy {
    expiration_period = each.value.sas_policy.expiration_period
  }

 dynamic "blob_properties" {
    for_each = each.value.blob_properties == null ? [] : [1]
    content {
      dynamic "delete_retention_policy" {
        for_each = each.value.blob_properties.delete_retention_policy == null ? [] : [1]
          content {
            days = each.value.blob_properties.delete_retention_policy.days
        }
      }
    }
  }

  dynamic "azure_files_authentication" {
    for_each = each.value.azure_files_authentication == null ? [] : [1]
    content {
      directory_type = each.value.azure_files_authentication.directory_type
      dynamic "active_directory" {
        for_each = each.value.azure_files_authentication.active_directory == null ? [] : [1]
        content {
          domain_guid = each.value.azure_files_authentication.active_directory.domain_guid
          domain_name = each.value.azure_files_authentication.active_directory.domain_name
          domain_sid = each.value.azure_files_authentication.active_directory.domain_sid
          forest_name = each.value.azure_files_authentication.active_directory.forest_name
          netbios_domain_name = each.value.azure_files_authentication.active_directory.netbios_domain_name
          storage_sid = each.value.azure_files_authentication.active_directory.storage_sid
        }
      }
    }
  }

  dynamic "network_rules" {
    for_each = each.value.network_rules == null ? [] : [1]
    content {
      default_action = each.value.network_rules.default_action
      ip_rules = each.value.network_rules.ip_rules
      virtual_network_subnet_ids = local.subnets[each.key].subnets
    }
  }

  lifecycle {
    ignore_changes = [
    azure_files_authentication
    ]
  }
}

data "azurerm_storage_account" "storage_accounts" {
  for_each = {
    for storage_account in local.storageaccounts : "${storage_account.key}" => storage_account if storage_account.existing == true
  }
  name = each.value.name
  resource_group_name = each.value.resource_group_name
}

