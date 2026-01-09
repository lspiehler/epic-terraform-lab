output "user_assigned_identity" {
    description = "User Assigned Identities"
    value = merge(azurerm_user_assigned_identity.user_assigned_identity, data.azurerm_user_assigned_identity.user_assigned_identity)
}