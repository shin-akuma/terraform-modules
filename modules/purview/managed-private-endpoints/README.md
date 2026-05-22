<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_null"></a> [null](#requirement_null) | >= 3.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider_null) | >= 3.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.adls_managed_endpoint](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.databricks_managed_endpoint](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_managed_private_endpoints"></a> [create_managed_private_endpoints](#input_create_managed_private_endpoints) | Whether to create managed private endpoints from Purview to data sources. | `bool` | `false` | no |
| <a name="input_enable_adls_managed_endpoint"></a> [enable_adls_managed_endpoint](#input_enable_adls_managed_endpoint) | Create a managed private endpoint from Purview to ADLS Gen2 storage. | `bool` | `false` | no |
| <a name="input_enable_databricks_managed_endpoint"></a> [enable_databricks_managed_endpoint](#input_enable_databricks_managed_endpoint) | Create a managed private endpoint from Purview to Databricks workspace. | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name) | Resource group name of the Purview account. | `string` | n/a | yes |
| <a name="input_purview_account_name"></a> [purview_account_name](#input_purview_account_name) | Purview account name. | `string` | n/a | yes |
| <a name="input_adls_storage_account_resource_id"></a> [adls_storage_account_resource_id](#input_adls_storage_account_resource_id) | Resource ID of the ADLS Gen2 storage account. | `string` | n/a | yes |
| <a name="input_databricks_workspace_resource_id"></a> [databricks_workspace_resource_id](#input_databricks_workspace_resource_id) | Resource ID of the Databricks workspace. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_managed_private_endpoints_created"></a> [managed_private_endpoints_created](#output_managed_private_endpoints_created) | List of managed private endpoints created by this module. |

## Notes

This module uses Azure CLI via local-exec to create managed private endpoints.
The `az` CLI must be installed and authenticated in the execution environment.
<!-- END_TF_DOCS -->
