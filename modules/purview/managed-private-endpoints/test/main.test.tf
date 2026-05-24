/*======================================================================
GLOBAL CONFIGURATION
======================================================================*/
terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.0"
    }
  }
}

variable "create_managed_private_endpoints" {
  type        = bool
  description = "Whether to create managed private endpoints from Purview to data sources."
  default     = false
}

variable "enable_adls_managed_endpoint" {
  type        = bool
  description = "Create a managed private endpoint from Purview to ADLS Gen2 storage."
  default     = false
}

variable "enable_databricks_managed_endpoint" {
  type        = bool
  description = "Create a managed private endpoint from Purview to Databricks workspace."
  default     = false
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name of the Purview account."
  default     = "rg-placeholder"
}

variable "purview_account_name" {
  type        = string
  description = "Purview account name."
  default     = "pvw-placeholder"
}

variable "adls_storage_account_resource_id" {
  type        = string
  description = "Resource ID of the ADLS Gen2 storage account."
  default     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/stplaceholder"
}

variable "databricks_workspace_resource_id" {
  type        = string
  description = "Resource ID of the Databricks workspace."
  default     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-placeholder"
}

/*======================================================================
TEST EXECUTION
======================================================================*/
module "managed_private_endpoints_disabled" {
  source = "../"

  create_managed_private_endpoints   = var.create_managed_private_endpoints
  enable_adls_managed_endpoint       = var.enable_adls_managed_endpoint
  enable_databricks_managed_endpoint = var.enable_databricks_managed_endpoint

  resource_group_name              = var.resource_group_name
  purview_account_name             = var.purview_account_name
  adls_storage_account_resource_id = var.adls_storage_account_resource_id
  databricks_workspace_resource_id = var.databricks_workspace_resource_id
}

output "managed_private_endpoints_created" {
  value = module.managed_private_endpoints_disabled.managed_private_endpoints_created
}
