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
  name     = "${var.short_identifier}-test-pvw-rg-${random_string.random.result}"
  location = var.location
}

/*======================================================================
TEST EXECUTION
======================================================================*/
module "purview_account" {
  source = "../"

  name                        = "${var.short_identifier}pvw${random_string.random.result}"
  resource_group_name         = azurerm_resource_group.test.name
  location                    = var.location
  managed_resource_group_name = "${var.short_identifier}-pvw-managed-${random_string.random.result}"
  tags = {
    environment = "test"
    module      = "purview-accounts"
  }
}
