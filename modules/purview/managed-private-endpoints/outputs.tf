output "managed_private_endpoints_created" {
  description = "List of managed private endpoints created by this module."
  value = concat(
    var.create_managed_private_endpoints && var.enable_adls_managed_endpoint ? ["pe-${var.purview_account_name}-adls"] : [],
    var.create_managed_private_endpoints && var.enable_databricks_managed_endpoint ? ["pe-${var.purview_account_name}-databricks"] : []
  )
}
