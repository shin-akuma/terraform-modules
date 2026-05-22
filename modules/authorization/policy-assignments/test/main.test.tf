/*======================================================================
GLOBAL CONFIGURATION
======================================================================*/

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.115.0"
    }
  }
}

provider "azurerm" {
  features {}

  skip_provider_registration = true
}

variable "short_identifier" {
  type        = string
  description = "Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints."
  default     = "arn"
}

/*======================================================================
TEST PREREQUISITES
======================================================================*/
locals {
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/013e242c-8828-4970-87b3-ab247555486d" // Azure Backup should be enabled for Virtual Machines builtin policy
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_management_group" "test" {
  name         = "${var.short_identifier}${random_string.random.result}"
  display_name = "${var.short_identifier}${random_string.random.result}"
}
/*======================================================================
TEST EXECUTION
======================================================================*/
module "policy_assignment_minimum" {
  source               = "../"
  name                 = "${var.short_identifier}${random_string.random.result}"
  display_name         = "Azure Backup should be enabled for Virtual Machines"
  description          = "Azure Backup should be enabled for Virtual Machines"
  policy_definition_id = local.policy_definition_id
  management_group_id  = azurerm_management_group.test.id
}

module "policy_assignment_maximum" {
  source               = "../"
  name                 = "${var.short_identifier}${random_string.random.result}"
  location             = "australiaeast"
  display_name         = "Azure Backup should be enabled for Virtual Machines"
  description          = "Azure Backup should be enabled for Virtual Machines"
  policy_definition_id = local.policy_definition_id
  management_group_id  = azurerm_management_group.test.id
  enforce              = true
  parameters           = "{ \"effect\": { \"value\": \"AuditIfNotExists\" } }"
  managed_identities = {
    system_assigned            = true
    user_assigned_resource_ids = []
  }
  non_compliance_message = {
    content = "This resource is not compliant with the policy."
  }
}

