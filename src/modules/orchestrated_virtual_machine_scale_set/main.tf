##Create all resource groups defined in the variable "rgs"
resource "azurerm_orchestrated_virtual_machine_scale_set" "orchestrated_virtual_machine_scale_set" {
  for_each = {
    for vm_scale_set in local.vm_scale_sets : "${vm_scale_set.key}" => vm_scale_set if vm_scale_set.existing == false
  }
  name = each.value.name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  platform_fault_domain_count = each.value.platform_fault_domain_count
  zones = each.value.zones
  encryption_at_host_enabled = each.value.encryption_at_host_enabled
  single_placement_group = each.value.single_placement_group
  tags = each.value.tags
}

##Get references to all existing resource groups defined in the variable "rgs"
data "azurerm_orchestrated_virtual_machine_scale_set" "orchestrated_virtual_machine_scale_set" {
  for_each = {
    for vm_scale_set in local.vm_scale_sets : "${vm_scale_set.key}" => vm_scale_set if vm_scale_set.existing == true
  }
  name = each.value.name
  resource_group_name = each.value.resource_group_name
}