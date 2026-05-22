# Add specific Azure resources using AzureRM or AzAPI providers
# AzureRM Provider Documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
# AzAPI Provider Documentation: https://learn.microsoft.com/en-us/azure/templates/#terraform-azapi-provider

/*======================================================================
Module Resource Blocks
======================================================================*/

locals {
  parent = "/providers/Microsoft.Management/managementGroups/${var.parent_management_group_name}"
}

resource "azurerm_management_group" "this" {
  name                       = var.name
  display_name               = var.display_name
  parent_management_group_id = local.parent
  subscription_ids           = var.subscription_ids
}