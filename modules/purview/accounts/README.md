<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement_azurerm) | >= 4.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) | >= 4.17.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_purview_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/purview_account) | resource |
| [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input_name) | The Purview account name. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name) | Resource group where the Purview account will be deployed. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input_location) | The Azure region for the Purview account. | `string` | n/a | yes |
| <a name="input_managed_resource_group_name"></a> [managed_resource_group_name](#input_managed_resource_group_name) | The managed resource group name used by Purview for internal resources. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input_tags) | Optional. Resource tags. | `map(string)` | `{}` | no |
| <a name="input_resource_lock_level"></a> [resource_lock_level](#input_resource_lock_level) | Optional. Specify the type of resource lock. Allowed values: 'CanNotDelete', 'ReadOnly' or 'None'. | `string` | `"None"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_id"></a> [resource_id](#output_resource_id) | The resource ID of the deployed Purview account. |
| <a name="output_name"></a> [name](#output_name) | The name of the deployed Purview account. |
| <a name="output_managed_identity_principal_id"></a> [managed_identity_principal_id](#output_managed_identity_principal_id) | The principal ID of the system-assigned managed identity. |
| <a name="output_catalog_endpoint"></a> [catalog_endpoint](#output_catalog_endpoint) | Purview catalog endpoint. |
| <a name="output_scan_endpoint"></a> [scan_endpoint](#output_scan_endpoint) | Purview scan endpoint. |
| <a name="output_managed_resource_group_id"></a> [managed_resource_group_id](#output_managed_resource_group_id) | The resource ID of the Purview managed resource group. |
<!-- END_TF_DOCS -->
