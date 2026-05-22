variable "locks" {
  type = map(object({
    resource_name = string
    resource_id   = string
    kind          = string
  }))
  description = "Map of locks to create. Key is a unique identifier, value contains lock configuration."

  validation {
    condition = alltrue([
      for lock in var.locks : contains(["CanNotDelete", "ReadOnly"], lock.kind)
    ])
    error_message = "Lock kind must be either 'CanNotDelete' or 'ReadOnly'."
  }
}
