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
  default     = null

  validation {
    condition     = !var.create_managed_private_endpoints || (var.resource_group_name != null && trimspace(var.resource_group_name) != "")
    error_message = "resource_group_name is required when create_managed_private_endpoints is true."
  }
}

variable "purview_account_name" {
  type        = string
  description = "Purview account name."
  default     = null

  validation {
    condition     = !var.create_managed_private_endpoints || (var.purview_account_name != null && trimspace(var.purview_account_name) != "")
    error_message = "purview_account_name is required when create_managed_private_endpoints is true."
  }
}

variable "adls_storage_account_resource_id" {
  type        = string
  description = "Resource ID of the ADLS Gen2 storage account."
  default     = null

  validation {
    condition     = !(var.create_managed_private_endpoints && var.enable_adls_managed_endpoint) || (var.adls_storage_account_resource_id != null && trimspace(var.adls_storage_account_resource_id) != "")
    error_message = "adls_storage_account_resource_id is required when create_managed_private_endpoints and enable_adls_managed_endpoint are both true."
  }
}

variable "databricks_workspace_resource_id" {
  type        = string
  description = "Resource ID of the Databricks workspace."
  default     = null

  validation {
    condition     = !(var.create_managed_private_endpoints && var.enable_databricks_managed_endpoint) || (var.databricks_workspace_resource_id != null && trimspace(var.databricks_workspace_resource_id) != "")
    error_message = "databricks_workspace_resource_id is required when create_managed_private_endpoints and enable_databricks_managed_endpoint are both true."
  }
}
