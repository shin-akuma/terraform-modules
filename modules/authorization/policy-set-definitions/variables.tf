# Create your variables required for your module here. Common required variables such as name, location, resource_group_name, tags have already been created, but can be removed if needed.
# Variables used for enabling diagnostic logging have also been included.
#
# See documentation: https://developer.hashicorp.com/terraform/language/values/variables

variable "name" {
  type        = string
  description = "The policy set definition name."
}

variable "display_name" {
  type        = string
  description = "The display name of the policy definition set."
}

variable "description" {
  type        = string
  description = "The description of the policy definition set."
}

variable "metadata" {
  type        = string
  description = "The metadata of the policy definition set."
  default     = ""
}

variable "parameters" {
  type        = string
  description = "The parameters of the policy definition set."
  default     = ""
}

variable "policy_definitions" {
  type        = list(map(string))
  description = "The policy definitions of the policy definition set."
}

variable "policy_definition_group" {
  type        = list(map(string))
  description = "The policy definition group of the policy definition set."
  default     = [{}]
}

variable "management_group_id" {
  type        = string
  description = "Optional. The management group scope at which the initiative will be defined. Defaults to current Subscription if omitted. Changing this forces a new resource to be created. Note: if you are using azurerm_management_group to assign a value to management_group_id, be sure to use name or group_id attribute, but not id."
  default     = null
}
