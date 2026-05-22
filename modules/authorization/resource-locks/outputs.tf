output "lock_ids" {
  description = "Map of lock IDs keyed by the input lock key"
  value       = { for k, v in azurerm_management_lock.this : k => v.id }
}

output "lock_names" {
  description = "Map of lock names keyed by the input lock key"
  value       = { for k, v in azurerm_management_lock.this : k => v.name }
}
