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
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input_name) | The resource group name. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input_location) | The Azure region for the resource group. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input_tags) | Optional. Resource tags. | `map(string)` | `{}` | no |
| <a name="input_resource_lock_level"></a> [resource_lock_level](#input_resource_lock_level) | Optional. Specify the type of resource lock. Allowed values: 'CanNotDelete', 'ReadOnly' or 'None'. | `string` | `"None"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_id"></a> [resource_id](#output_resource_id) | The resource ID of the deployed resource group. |
| <a name="output_name"></a> [name](#output_name) | The name of the deployed resource group. |
| <a name="output_location"></a> [location](#output_location) | The location of the deployed resource group. |
<!-- END_TF_DOCS -->
