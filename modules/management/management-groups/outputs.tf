# Create outputs for your module. Must output 'resource_id' and 'name' as a minimum.
# See documentation: https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-outputs

output "resource_id" {
  value = azurerm_management_group.this.id
}

output "name" {
  value = azurerm_management_group.this.name
}