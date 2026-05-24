variable "name" {
  type        = string
  description = "The Purview account name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where the Purview account will be deployed."
}

variable "location" {
  type        = string
  description = "The Azure region for the Purview account."
}

variable "managed_resource_group_name" {
  type        = string
  description = "The managed resource group name used by Purview for internal resources."
}

variable "tags" {
  type        = map(string)
  description = "Optional. Resource tags."
  default     = {}
}

variable "resource_lock_level" {
  type        = string
  description = "Optional. Specify the type of resource lock. Allowed values: 'CanNotDelete', 'ReadOnly' or 'None'."
  default     = "None"

  validation {
    condition     = contains(["CanNotDelete", "ReadOnly", "None"], var.resource_lock_level)
    error_message = "resource_lock_level must be one of: CanNotDelete, ReadOnly, or None."
  }
}
