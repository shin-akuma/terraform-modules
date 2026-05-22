# Add specific Azure resources using AzureRM or AzAPI providers
# AzureRM Provider Documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
# AzAPI Provider Documentation: https://learn.microsoft.com/en-us/azure/templates/#terraform-azapi-provider

/*======================================================================
Module Resource Blocks
======================================================================*/
resource "azurerm_policy_set_definition" "this" {
  policy_type         = "Custom"
  name                = var.name
  display_name        = var.display_name
  description         = var.description
  metadata            = var.metadata != null ? var.metadata : null
  parameters          = var.parameters != null ? var.parameters : null
  management_group_id = var.management_group_id != null ? "/providers/Microsoft.Management/managementGroups/${var.management_group_id}" : null
  dynamic "policy_definition_reference" {
    for_each = var.policy_definitions
    content {
      policy_definition_id = policy_definition_reference.value.policy_definition_id
      parameter_values     = policy_definition_reference.value.parameter_values
    }
  }
}
