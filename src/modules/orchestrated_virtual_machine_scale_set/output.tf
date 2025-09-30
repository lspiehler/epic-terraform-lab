output "orchestrated_virtual_machine_scale_set" {
    description = "Virtual machine scale set resources"
    value = merge(azurerm_orchestrated_virtual_machine_scale_set.orchestrated_virtual_machine_scale_set, data.azurerm_orchestrated_virtual_machine_scale_set.orchestrated_virtual_machine_scale_set)
}