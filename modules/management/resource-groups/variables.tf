variable "name" {
  type        = string
  description = "The resource group name."
}

variable "location" {
  type        = string
  description = "The Azure region for the resource group."
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
}
