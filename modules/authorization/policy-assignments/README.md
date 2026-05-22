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
| [azurerm_management_group_policy_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.115.0/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.115.0/docs/resources/role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | The description of the policy assignment. | `string` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name of the policy assignment. | `string` | n/a | yes |
| <a name="input_enforce"></a> [enforce](#input\_enforce) | Optional. Whether the policy assignment is enforced. | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | Optional. The location of the resource. | `string` | `null` | no |
| <a name="input_managed_identities"></a> [managed\_identities](#input\_managed\_identities) | Optional. Controls the Managed Identity configuration on this resource. The following properties can be specified:<br><br>  - `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.<br>  - `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource. | <pre>object({<br>    system_assigned            = optional(bool, false)<br>    user_assigned_resource_ids = optional(set(string), [])<br>  })</pre> | `{}` | no |
| <a name="input_management_group_id"></a> [management\_group\_id](#input\_management\_group\_id) | The ID of the management group. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The resource name. | `string` | n/a | yes |
| <a name="input_non_compliance_message"></a> [non\_compliance\_message](#input\_non\_compliance\_message) | Optional. The non-compliance message of the policy assignment. | <pre>object({<br>    content                        = string<br>    policy_definition_reference_id = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | Optional. The parameters of the policy assignment. | `string` | `null` | no |
| <a name="input_policy_definition_id"></a> [policy\_definition\_id](#input\_policy\_definition\_id) | The ID of the policy definition. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | The name of the deployed policy assignment. |
| <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id) | The resource ID of the deployed policy assignment. |
| <a name="output_system_assigned_identity_principal_id"></a> [system\_assigned\_identity\_principal\_id](#output\_system\_assigned\_identity\_principal\_id) | The principal ID of the system assigned identity. |
<!-- END_TF_DOCS -->