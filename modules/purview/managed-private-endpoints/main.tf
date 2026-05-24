resource "null_resource" "adls_managed_endpoint" {
  count = var.create_managed_private_endpoints && var.enable_adls_managed_endpoint ? 1 : 0

  triggers = {
    purview_account_name = coalesce(var.purview_account_name, "")
    resource_group_name  = coalesce(var.resource_group_name, "")
    adls_resource_id     = coalesce(var.adls_storage_account_resource_id, "")
    endpoint_name        = "pe-${var.purview_account_name}-adls"
  }

  provisioner "local-exec" {
    command = "az purview account managed-resource create-private-endpoint --resource-group \"${self.triggers.resource_group_name}\" --account-name \"${self.triggers.purview_account_name}\" --endpoint-name \"${self.triggers.endpoint_name}\" --api-type \"StorageAccount\" --target-resource-id \"${self.triggers.adls_resource_id}\""
  }

  provisioner "local-exec" {
    when    = destroy
    command = "az purview account managed-resource delete-private-endpoint --resource-group \"${self.triggers.resource_group_name}\" --account-name \"${self.triggers.purview_account_name}\" --endpoint-name \"${self.triggers.endpoint_name}\" --yes"
  }
}

resource "null_resource" "databricks_managed_endpoint" {
  count = var.create_managed_private_endpoints && var.enable_databricks_managed_endpoint ? 1 : 0

  triggers = {
    purview_account_name   = coalesce(var.purview_account_name, "")
    resource_group_name    = coalesce(var.resource_group_name, "")
    databricks_resource_id = coalesce(var.databricks_workspace_resource_id, "")
    endpoint_name          = "pe-${var.purview_account_name}-databricks"
  }

  provisioner "local-exec" {
    command = "az purview account managed-resource create-private-endpoint --resource-group \"${self.triggers.resource_group_name}\" --account-name \"${self.triggers.purview_account_name}\" --endpoint-name \"${self.triggers.endpoint_name}\" --api-type \"Databricks\" --target-resource-id \"${self.triggers.databricks_resource_id}\""
  }

  provisioner "local-exec" {
    when    = destroy
    command = "az purview account managed-resource delete-private-endpoint --resource-group \"${self.triggers.resource_group_name}\" --account-name \"${self.triggers.purview_account_name}\" --endpoint-name \"${self.triggers.endpoint_name}\" --yes"
  }
}
