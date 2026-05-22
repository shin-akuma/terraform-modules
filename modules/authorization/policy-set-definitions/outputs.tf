# Create outputs for your module. Must output 'resource_id' and 'name' as a minimum.
# See documentation: https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-outputs

output "resource_id" {
  value       = azurerm_policy_set_definition.this.id
  description = "The resource ID of the deployed policy set definition."
}

output "name" {
  value       = azurerm_policy_set_definition.this.name
  description = "The name of the deployed policy set definition."
}

