/*======================================================================
GLOBAL CONFIGURATION
======================================================================*/

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.7.0"
    }
  }
}

provider "azurerm" {
  features {}

  resource_provider_registrations = "none"
  subscription_id                 = "00000000-0000-0000-0000-000000000000" # Update to use your subscription ID for testing
}

variable "short_identifier" {
  type        = string
  description = "Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints."
  default     = "arn"
}

/*======================================================================
TEST PREREQUISITES
======================================================================*/

data "azurerm_client_config" "current" {}

/*======================================================================
TEST EXECUTION
======================================================================*/

module "management_groups_parent" {
  source = "../"

  name                         = "${var.short_identifier}-tst-parent-mg"
  display_name                 = "Arinco Test Management Group Parent"
  parent_management_group_name = data.azurerm_client_config.current.tenant_id
}

module "management_groups_child" {
  source = "../"

  name                         = "${var.short_identifier}-tst-child-mg"
  display_name                 = "Arinco Test Management Group Child"
  parent_management_group_name = module.management_groups_parent.name
  subscription_ids             = [] # Due to a bug, leaving this filled in will cause issues when running a terraform destroy. The subscription GUID must be removed first, applied, then you can destroy
}