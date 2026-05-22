output "resource_ids" {
  value       = { for k, v in azurerm_role_assignment.this : k => v.id }
  description = "Map of role assignment IDs keyed by input assignment key."
}
