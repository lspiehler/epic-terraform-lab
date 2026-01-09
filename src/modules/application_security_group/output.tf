output "application_security_group" {
    description = "Application Security Groups"
    value = merge(azurerm_application_security_group.application_security_group, data.azurerm_application_security_group.application_security_group)
}