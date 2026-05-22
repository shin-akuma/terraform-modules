/*======================================================================
GLOBAL CONFIGURATION
======================================================================*/

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.39.0"
    }
  }
}

provider "azurerm" {
  features {}

  resource_provider_registrations = "none"
}

/*======================================================================
TEST PREREQUISITES
======================================================================*/

data "azurerm_client_config" "current" {}

/*======================================================================
TEST EXECUTION
======================================================================*/

## TEST CURRENTLY BACKLOGGED