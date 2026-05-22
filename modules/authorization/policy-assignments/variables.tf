# Create your variables required for your module here. Common required variables such as name, location, resource_group_name, tags have already been created, but can be removed if needed.
# Variables used for enabling diagnostic logging have also been included.
#
# See documentation: https://developer.hashicorp.com/terraform/language/values/variables

variable "name" {
  type        = string
  description = "The resource name."
}

variable "location" {
  type        = string
  description = "Optional. The location of the resource."
  default     = null
}

variable "policy_definition_id" {
  type        = string
  description = "The ID of the policy definition."
}

variable "management_group_id" {
  type        = string
  description = "The ID of the management group."
}

variable "description" {
  type        = string
  description = "The description of the policy assignment."
}

variable "display_name" {
  type        = string
  description = "The display name of the policy assignment."
}

variable "enforce" {
  type        = bool
  description = "Optional. Whether the policy assignment is enforced."
  default     = true
}

variable "managed_identities" {
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  description = <<DESCRIPTION
  Optional. Controls the Managed Identity configuration on this resource. The following properties can be specified:

  - `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.
  - `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource.
  DESCRIPTION
  nullable    = false
  default     = {}
}

variable "non_compliance_message" {
  type = object({
    content                        = string
    policy_definition_reference_id = optional(string)
  })
  description = "Optional. The non-compliance message of the policy assignment."
  default     = null
}

variable "parameters" {
  type        = string
  description = "Optional. The parameters of the policy assignment."
  default     = null
}
