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

/*======================================================================
TEST EXECUTION
======================================================================*/
module "managed_private_endpoints_disabled" {
  source = "../"

  create_managed_private_endpoints   = false
  enable_adls_managed_endpoint       = false
  enable_databricks_managed_endpoint = false

  resource_group_name              = "rg-placeholder"
  purview_account_name             = "pvw-placeholder"
  adls_storage_account_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/stplaceholder"
  databricks_workspace_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-placeholder"
}
