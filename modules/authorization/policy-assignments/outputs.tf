output "resource_id" {
  value       = azurerm_management_group_policy_assignment.this.id
  description = "The resource ID of the deployed policy assignment."
}

output "name" {
  value       = azurerm_management_group_policy_assignment.this.name
  description = "The name of the deployed policy assignment."
}

output "system_assigned_identity_principal_id" {
  value       = var.managed_identities.system_assigned ? azurerm_management_group_policy_assignment.this.identity[0].principal_id : null
  description = "The principal ID of the system assigned identity."
}
