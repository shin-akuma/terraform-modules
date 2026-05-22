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
}

variable "purview_account_name" {
  type        = string
  description = "Purview account name."
}

variable "adls_storage_account_resource_id" {
  type        = string
  description = "Resource ID of the ADLS Gen2 storage account."
}

variable "databricks_workspace_resource_id" {
  type        = string
  description = "Resource ID of the Databricks workspace."
}
