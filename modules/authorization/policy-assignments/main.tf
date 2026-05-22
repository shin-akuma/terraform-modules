# Add specific Azure resources using AzureRM or AzAPI providers
# AzureRM Provider Documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
# AzAPI Provider Documentation: https://learn.microsoft.com/en-us/azure/templates/#terraform-azapi-provider

/*======================================================================
Module Resource Blocks
======================================================================*/
resource "azurerm_management_group_policy_assignment" "this" {
  name                 = var.name
  policy_definition_id = var.policy_definition_id
  management_group_id  = var.management_group_id
  description          = var.description
  display_name         = var.display_name
  enforce              = var.enforce
  location             = var.location != null ? var.location : null
  dynamic "identity" {
    for_each = (var.managed_identities.system_assigned || length(var.managed_identities.user_assigned_resource_ids) > 0) ? { this = var.managed_identities } : {}
    content {
      type         = identity.value.system_assigned && length(identity.value.user_assigned_resource_ids) > 0 ? "SystemAssigned, UserAssigned" : length(identity.value.user_assigned_resource_ids) > 0 ? "UserAssigned" : "SystemAssigned"
      identity_ids = identity.value.user_assigned_resource_ids
    }
  }
  dynamic "non_compliance_message" {
    for_each = var.non_compliance_message != null ? { this = var.non_compliance_message } : {}
    content {
      content                        = non_compliance_message.value.content
      policy_definition_reference_id = non_compliance_message.value.policy_definition_reference_id != null ? non_compliance_message.value.policy_definition_reference_id : null

    }
  }
  parameters = var.parameters
}

resource "azurerm_role_assignment" "this" {
  count              = var.managed_identities.system_assigned ? 1 : 0
  scope              = var.management_group_id
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c" // Contributor role required for policy with deployIfNotExists/modify effects
  principal_id       = azurerm_management_group_policy_assignment.this.identity[0].principal_id
  principal_type     = "ServicePrincipal"
}
