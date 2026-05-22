<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.115.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.115.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_policy_set_definition.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.115.0/docs/resources/policy_set_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | The description of the policy definition set. | `string` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name of the policy definition set. | `string` | n/a | yes |
| <a name="input_management_group_id"></a> [management\_group\_id](#input\_management\_group\_id) | Optional. The management group scope at which the initiative will be defined. Defaults to current Subscription if omitted. Changing this forces a new resource to be created. Note: if you are using azurerm\_management\_group to assign a value to management\_group\_id, be sure to use name or group\_id attribute, but not id. | `string` | `null` | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | The metadata of the policy definition set. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | The policy set definition name. | `string` | n/a | yes |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | The parameters of the policy definition set. | `string` | `""` | no |
| <a name="input_policy_definition_group"></a> [policy\_definition\_group](#input\_policy\_definition\_group) | The policy definition group of the policy definition set. | `list(map(string))` | <pre>[<br>  {}<br>]</pre> | no |
| <a name="input_policy_definitions"></a> [policy\_definitions](#input\_policy\_definitions) | The policy definitions of the policy definition set. | `list(map(string))` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | The name of the deployed policy set definition. |
| <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id) | The resource ID of the deployed policy set definition. |
<!-- END_TF_DOCS -->