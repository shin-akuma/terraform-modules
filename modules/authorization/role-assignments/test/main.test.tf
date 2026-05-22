/*======================================================================
GLOBAL CONFIGURATION
======================================================================*/
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.17.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "azurerm" {
  features {}

  resource_provider_registrations = "none"
}

variable "location" {
  type        = string
  description = "Optional. The geo-location where the resource lives."
  default     = "australiaeast"
}

variable "short_identifier" {
  type        = string
  description = "Optional. A short identifier for the kind of deployment."
  default     = "arn"
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "test" {
  name     = "${var.short_identifier}-test-ra-rg-${random_string.random.result}"
  location = var.location
}

resource "azurerm_user_assigned_identity" "test" {
  name                = "${var.short_identifier}-test-ra-uai-${random_string.random.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.test.name
}

/*======================================================================
TEST EXECUTION
======================================================================*/
module "role_assignments" {
  source = "../"

  role_assignments = {
    reader_on_rg = {
      scope                = azurerm_resource_group.test.id
      principal_id         = azurerm_user_assigned_identity.test.principal_id
      role_definition_name = "Reader"
      description          = "Test role assignment"
    }
  }
}
