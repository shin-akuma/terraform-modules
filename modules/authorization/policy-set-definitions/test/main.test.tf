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
  initiatives = {
    "initiative1" : jsondecode(file("main.test.initiative.json")),
    "initiative2" : jsondecode(file("main.test.initiative.basic.json"))
  }
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
module "policy_set_definition_minimum" {
  for_each     = local.initiatives
  source       = "../"
  display_name = each.value.displayName
  name         = each.value.name
  description  = each.value.description
  metadata     = contains(keys(each.value), "metadata") ? jsonencode(each.value.metadata) : null
  parameters   = contains(keys(each.value), "parameters") ? jsonencode(each.value.parameters) : null
  policy_definitions = [
    for definition in each.value.policyDefinitions :
    {
      policy_definition_id = definition.policyDefinitionId
      parameter_values     = jsonencode(definition.parameters)
    }
  ]
}

module "policy_set_definition_maximum" {
  for_each            = local.initiatives
  source              = "../"
  display_name        = each.value.displayName
  name                = each.value.name
  description         = each.value.description
  metadata            = contains(keys(each.value), "metadata") ? jsonencode(each.value.metadata) : null
  parameters          = contains(keys(each.value), "parameters") ? jsonencode(each.value.parameters) : null
  management_group_id = azurerm_management_group.test.name
  policy_definitions = [
    for definition in each.value.policyDefinitions :
    {
      policy_definition_id = definition.policyDefinitionId
      parameter_values     = jsonencode(definition.parameters)
    }
  ]
}
