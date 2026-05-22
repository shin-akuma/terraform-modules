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
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_role_assignments"></a> [role_assignments](#input_role_assignments) | Map of role assignments to create. Each object must define scope and principal_id, and either role_definition_name or role_definition_id. | <pre>map(object({<br/>scope = string<br/>principal_id = string<br/>role_definition_name = optional(string)<br/>role_definition_id = optional(string)<br/>description = optional(string)<br/>principal_type = optional(string)<br/>}))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_ids"></a> [resource_ids](#output_resource_ids) | Map of role assignment IDs keyed by input assignment key. |
<!-- END_TF_DOCS -->
