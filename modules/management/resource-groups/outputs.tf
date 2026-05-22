output "resource_id" {
  value       = azurerm_resource_group.this.id
  description = "The resource ID of the deployed resource group."
}

output "name" {
  value       = azurerm_resource_group.this.name
  description = "The name of the deployed resource group."
}

output "location" {
  value       = azurerm_resource_group.this.location
  description = "The location of the deployed resource group."
}
