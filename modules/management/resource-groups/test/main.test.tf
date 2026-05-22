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

/*======================================================================
TEST EXECUTION
======================================================================*/
module "resource_group_minimum" {
  source = "../"

  name     = "${var.short_identifier}-test-rg-min-${random_string.random.result}"
  location = var.location
}

module "resource_group_with_lock" {
  source = "../"

  name                = "${var.short_identifier}-test-rg-max-${random_string.random.result}"
  location            = var.location
  resource_lock_level = "CanNotDelete"
  tags = {
    environment = "test"
    module      = "resource-groups"
  }
}
