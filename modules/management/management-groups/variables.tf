# Create your variables required for your module here. Common required variables such as name, location, resource_group_name, tags have already been created, but can be removed if needed.
# Variables used for enabling diagnostic logging have also been included.
#
# See documentation: https://developer.hashicorp.com/terraform/language/values/variables

variable "name" {
  type        = string
  description = "Optional. The resource name."
  default     = null
}

variable "display_name" {
  type        = string
  description = "The friendly name of the management group."
}

variable "parent_management_group_name" {
  type        = string
  description = "Optional. The name of the parent management group. To deploy your management group under the Tenant Root Group, enter the Tenant ID"
  default     = null
}

variable "subscription_ids" {
  type        = list(string)
  description = "Optional. A list of subscription GUID's which should be assigned to the management group."
  default     = []
}
