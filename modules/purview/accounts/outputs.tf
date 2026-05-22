output "resource_id" {
  value       = azurerm_purview_account.this.id
  description = "The resource ID of the deployed Purview account."
}

output "name" {
  value       = azurerm_purview_account.this.name
  description = "The name of the deployed Purview account."
}

output "managed_identity_principal_id" {
  value       = azurerm_purview_account.this.identity[0].principal_id
  description = "The principal ID of the system-assigned managed identity."
}

output "catalog_endpoint" {
  value       = azurerm_purview_account.this.catalog_endpoint
  description = "Purview catalog endpoint."
}

output "scan_endpoint" {
  value       = azurerm_purview_account.this.scan_endpoint
  description = "Purview scan endpoint."
}

output "managed_resource_group_id" {
  value       = azurerm_purview_account.this.managed_resources[0].resource_group_id
  description = "The resource ID of the Purview managed resource group."
}
