variable "role_assignments" {
  type = map(object({
    scope                = string
    principal_id         = string
    role_definition_name = optional(string)
    role_definition_id   = optional(string)
    description          = optional(string)
    principal_type       = optional(string)
  }))
  description = "Map of role assignments to create. Each object must define scope and principal_id, and either role_definition_name or role_definition_id."

  validation {
    condition = alltrue([
      for k, v in var.role_assignments :
      (try(v.role_definition_name, null) != null) != (try(v.role_definition_id, null) != null)
    ])
    error_message = "Each role assignment must specify exactly one of role_definition_name or role_definition_id."
  }
}
