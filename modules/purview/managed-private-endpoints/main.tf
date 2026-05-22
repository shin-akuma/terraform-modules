resource "null_resource" "adls_managed_endpoint" {
  count = var.create_managed_private_endpoints && var.enable_adls_managed_endpoint ? 1 : 0

  triggers = {
    purview_account_name = var.purview_account_name
    resource_group_name  = var.resource_group_name
    adls_resource_id     = var.adls_storage_account_resource_id
  }

  provisioner "local-exec" {
    command = <<-EOT
      az purview account managed-resource create-private-endpoint \
        --resource-group "${var.resource_group_name}" \
        --account-name "${var.purview_account_name}" \
        --endpoint-name "pe-${var.purview_account_name}-adls" \
        --api-type "StorageAccount" \
        --target-resource-id "${var.adls_storage_account_resource_id}"
    EOT
  }
}

resource "null_resource" "databricks_managed_endpoint" {
  count = var.create_managed_private_endpoints && var.enable_databricks_managed_endpoint ? 1 : 0

  triggers = {
    purview_account_name   = var.purview_account_name
    resource_group_name    = var.resource_group_name
    databricks_resource_id = var.databricks_workspace_resource_id
  }

  provisioner "local-exec" {
    command = <<-EOT
      az purview account managed-resource create-private-endpoint \
        --resource-group "${var.resource_group_name}" \
        --account-name "${var.purview_account_name}" \
        --endpoint-name "pe-${var.purview_account_name}-databricks" \
        --api-type "Databricks" \
        --target-resource-id "${var.databricks_workspace_resource_id}"
    EOT
  }
}
