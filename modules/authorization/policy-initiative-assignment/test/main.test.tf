/*======================================================================
GLOBAL CONFIGURATION
======================================================================*/

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      #   version = "~> 4.7.0" # Update to be the desired version
    }
    azapi = {
      source = "Azure/azapi"
      #   version = "~> 2.0.1" # Update to be the desired version
    }
  }
}

provider "azurerm" {
  features {}

  resource_provider_registrations = "none"
}

# Remove if not using AzAPI provider
provider "azapi" {
  # Configuration options
}

variable "location" {
  type        = string
  description = "Optional. The geo-location where the resource lives."
  default     = "australiaeast"
}

variable "short_identifier" {
  type        = string
  description = "Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints."
  default     = "arn"
}

/*======================================================================
TEST PREREQUISITES
======================================================================*/
resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "test" {
  name     = "rg-${var.short_identifier}-${random_string.random.result}"
  location = var.location
}

resource "azurerm_storage_account" "logging_storage_account" {
  name                     = "${var.short_identifier}${random_string.random.result}"
  resource_group_name      = azurerm_resource_group.test.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"
}

resource "azurerm_storage_management_policy" "logging_storage_account" {
  storage_account_id = azurerm_storage_account.logging_storage_account.id
  rule {
    name    = "blob-lifecycle"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than = 30
        delete_after_days_since_modification_greater_than       = 365
      }
      snapshot {
        delete_after_days_since_creation_greater_than = 365
      }
    }
  }
}

resource "azurerm_log_analytics_workspace" "logging_law" {
  name                = "${var.short_identifier}${random_string.random.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.test.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Add additional required resources needed in order to deploy your test.

/*======================================================================
TEST EXECUTION
======================================================================*/

# Two module tests module tests required at a minimum. One with the bare minimum attributes supplied and a second one (or more) using all attributes (or scenarios).
# Rename the module to reflect the resource being deploy. i.e., key_vault_minimum.

## TEST CURRENTLY ON BACKLOG

module "resource_type_minimum" {
  source = "../"

  # parameter_name = "parameter_value"
}

module "resource_type_maximum" {
  source = "../"

  # parameter_name = "parameter_value"
}
