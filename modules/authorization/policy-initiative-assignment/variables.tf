variable "initiative" {
  type        = any
  description = "Policy Initiative resource node"
}

variable "assignment_scope" {
  type        = string
  description = "The scope at which the policy initiative will be assigned. Must be full resource IDs. Changing this forces a new resource to be created"
}

variable "assignment_not_scopes" {
  type        = list(string)
  description = "A list of the Policy Assignment's excluded scopes. Must be full resource IDs"
  default     = []
}

variable "assignment_name" {
  type        = string
  description = "The name which should be used for this Policy Assignment, defaults to initiative name. Changing this forces a new Policy Assignment to be created"
  default     = null
}

variable "assignment_display_name" {
  type        = string
  description = "The policy assignment display name, defaults to initiative display_name. Changing this forces a new resource to be created"
  default     = null
}

variable "assignment_description" {
  type        = string
  description = "A description to use for the Policy Assignment, defaults to initiative description. Changing this forces a new resource to be created"
  default     = null
}

variable "assignment_effect" {
  type        = string
  description = "The effect of the set assignment. Useful when the initiative has multiple effects of the same type and 'merge_effects=true'. Omit this to use each definitions default effect or populate individually at 'assignment_parameters'"
  default     = null
}

variable "assignment_parameters" {
  type        = any
  description = "The policy assignment parameters. Changing this forces a new resource to be created"
  default     = null
}

variable "assignment_metadata" {
  type        = any
  description = "The optional metadata for the policy assignment."
  default     = null
}

variable "assignment_enforcement_mode" {
  type        = bool
  description = "Control whether the assignment is enforced"
  default     = true
}

variable "assignment_location" {
  type        = string
  description = "The Azure location where this policy assignment should exist, required when an Identity is assigned. Defaults to Australia East. Changing this forces a new resource to be created"
  default     = "australiaeast"
}

variable "non_compliance_messages" {
  type        = any
  description = "The optional non-compliance message(s). Key/Value pairs map as policy_definition_reference_id = 'content', use null = 'content' to specify the Default non-compliance message for all member definitions."
  default     = {}
}

variable "overrides" {
  type        = list(any)
  description = "Optional list of assignment Overrides (preview), max 10. Allows you to change the effect of a policy definition without modifying the underlying policy definition or using a parameterized effect in the policy definition"
  default     = []
}

variable "resource_selectors" {
  type        = list(any)
  description = "Optional list of Resource selectors (preview), max 10. These facilitate safe deployment practices (SDP) by enabling you to gradually roll out policy assignments based on factors like resource location, resource type, or whether a resource has a location"
  default     = []
}

variable "identity_ids" {
  type        = list(string)
  description = "Optional list of User Managed Identity IDs which should be assigned to the Policy Initiative"
  default     = null
}

variable "re_evaluate_compliance" {
  type        = bool
  description = "Sets the remediation task resource_discovery_mode for policies that DeployIfNotExists and Modify. false = 'ExistingNonCompliant' and true = 'ReEvaluateCompliance'. Defaults to false. Applies at subscription scope and below"
  default     = false
}

variable "remediation_scope" {
  type        = string
  description = "The scope at which the remediation tasks will be created. Must be full resource IDs. Defaults to the policy assignment scope. Changing this forces a new resource to be created"
  default     = null
}

variable "location_filters" {
  type        = list(string)
  description = "Optional list of the resource locations that will be remediated"
  default     = []
}

variable "failure_percentage" {
  type        = number
  description = "(Optional) A number between 0.0 to 1.0 representing the percentage failure threshold. The remediation will fail if the percentage of failed remediation operations (i.e. failed deployments) exceeds this threshold."
  default     = null
}

variable "parallel_deployments" {
  type        = number
  description = "(Optional) Determines how many resources to remediate at any given time. Can be used to increase or reduce the pace of the remediation. If not provided, the default parallel deployments value is used."
  default     = null
}

variable "resource_count" {
  type        = number
  description = "(Optional) Determines the max number of resources that can be remediated by the remediation job. If not provided, the default resource count is used."
  default     = null
}

variable "aad_group_remediation_object_ids" {
  type        = list(string)
  description = "List of Azure AD Group Object Ids for the System Assigned Identity to be a member of. Omit this to use role_assignments"
  default     = []
}

variable "role_definition_ids" {
  type        = list(string)
  description = "List of Role definition ID's for the System Assigned Identity. Omit this to use those located in policy definitions. Ignored when using Managed Identities. Changing this forces a new resource to be created"
  default     = []
}

variable "role_assignment_scope" {
  type        = string
  description = "The scope at which role definition(s) will be assigned, defaults to Policy Assignment Scope. Must be full resource IDs. Ignored when using Managed Identities. Changing this forces a new resource to be created"
  default     = null
}

variable "role_assignment_linked_scope" {
  type        = string
  description = "The linked scope at which role definition(s) will be assigned e.g. for Policy Assignment identity access to centralised Log Analytics Workspaces. Must be full resource IDs. Ignored when using Managed Identities. Changing this forces a new resource to be created"
  default     = null
}

variable "skip_remediation" {
  type        = bool
  description = "Should the module skip creation of a remediation task for policies that DeployIfNotExists and Modify"
  default     = true
}

variable "skip_role_assignment" {
  type        = bool
  description = "Should the module skip creation of role assignment for policies that DeployIfNotExists and Modify"
  default     = false
}

locals {
  # assignment_name at MG scope will be trimmed if exceeds 24 characters
  assignment_name_trim = local.assignment_scope.mg > 0 ? 24 : 64
  assignment_name      = try(lower(substr(coalesce(var.assignment_name, var.initiative.name), 0, local.assignment_name_trim)), "")
  display_name         = try(coalesce(var.assignment_display_name, var.initiative.display_name), "")
  description          = try(coalesce(var.assignment_description, var.initiative.description), "")
  metadata             = jsonencode(try(coalesce(var.assignment_metadata, jsondecode(var.initiative.metadata)), {}))

  # convert assignment parameters to the required assignment structure
  parameter_values = var.assignment_parameters != null ? {
    for k, v in var.assignment_parameters :
    k => merge({ value = v })
  } : null

  # merge effect and parameter_values if specified, will use definition default effects if omitted
  parameters = local.parameter_values != null ? var.assignment_effect != null ? jsonencode(merge(local.parameter_values, { effect = { value = var.assignment_effect } })) : jsonencode(local.parameter_values) : null

  # determine if a managed identity should be created with this assignment
  identity_type = length(try(coalescelist(var.role_definition_ids, try(var.initiative.role_definition_ids, [])), [])) > 0 ? var.identity_ids != null ? { type = "UserAssigned" } : { type = "SystemAssigned" } : {}

  # try to use policy definition roles if explicit roles are omitted
  role_definition_ids = var.skip_role_assignment == false && length(var.aad_group_remediation_object_ids) == 0 && try(values(local.identity_type)[0], "") == "SystemAssigned" ? try(coalescelist(var.role_definition_ids, try(var.initiative.role_definition_ids, [])), []) : []

  # create role definition names mapping for role assignments (more stable than IDs)
  role_definition_names = var.skip_role_assignment == false && length(var.aad_group_remediation_object_ids) == 0 && try(values(local.identity_type)[0], "") == "SystemAssigned" ? {
    for idx, role_id in try(coalescelist(var.role_definition_ids, try(var.initiative.role_definition_ids, [])), []) :
    # Use index + scope hash + first 8 characters to ensure uniqueness across multiple assignments of same role
    "${idx}-${substr(md5(coalesce(var.role_assignment_scope, var.assignment_scope)), 0, 8)}-${substr(regex("[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}", role_id), 0, 8)}" => (
      # Map common role definition GUIDs to their role names using regex matching
      length(regexall("b24988ac-6180-42a0-ab88-20f7382dd24c", role_id)) > 0 ? "Contributor" :
      length(regexall("9980e02c-c2be-4d73-94e8-173b1dc7cf3c", role_id)) > 0 ? "Virtual Machine Contributor" :
      length(regexall("749f88d5-cbae-40b8-bcfc-e573ddc772fa", role_id)) > 0 ? "Monitoring Contributor" :
      length(regexall("92aaf0da-9dab-42b6-94a3-d43ce8d16293", role_id)) > 0 ? "Log Analytics Contributor" :
      length(regexall("17d1049b-9a84-46fb-8f53-869881c3d3ab", role_id)) > 0 ? "Storage Account Contributor" :
      length(regexall("ba92f5b4-2d11-453d-a403-e96b0029c9fe", role_id)) > 0 ? "Storage Blob Data Contributor" :
      length(regexall("f1a07417-d97a-45cb-824c-7a7467783830", role_id)) > 0 ? "Managed Identity Operator" :
      length(regexall("e40ec5ca-96e0-45a2-b4ff-59039f2c2b59", role_id)) > 0 ? "Managed Identity Contributor" :
      # Default fallback - extract role name from common patterns or use a generic name
      "Contributor"
    )
  } : {}

  # assignment location is required when identity is specified
  assignment_location = length(local.identity_type) > 0 ? var.assignment_location : null

  # evaluate policy assignment scope from resource identifier
  assignment_scope = {
    mg       = length(regexall("(\\/managementGroups\\/)", var.assignment_scope)) > 0 ? 1 : 0,
    sub      = length(split("/", var.assignment_scope)) == 3 ? 1 : 0,
    rg       = length(regexall("(\\/managementGroups\\/)", var.assignment_scope)) < 1 ? length(split("/", var.assignment_scope)) == 5 ? 1 : 0 : 0,
    resource = length(split("/", var.assignment_scope)) >= 6 ? 1 : 0,
  }

  # evaluate remediation scope from resource identifier
  resource_discovery_mode = var.re_evaluate_compliance == true ? "ReEvaluateCompliance" : "ExistingNonCompliant"
  remediation_scope       = coalesce(var.remediation_scope, var.assignment_scope)
  remediate = {
    mg       = length(regexall("(\\/managementGroups\\/)", local.remediation_scope)) > 0 ? 1 : 0,
    sub      = length(split("/", local.remediation_scope)) == 3 ? 1 : 0,
    rg       = length(regexall("(\\/managementGroups\\/)", local.remediation_scope)) < 1 ? length(split("/", local.remediation_scope)) == 5 ? 1 : 0 : 0,
    resource = length(split("/", local.remediation_scope)) >= 6 ? 1 : 0,
  }

  # retrieve definition references & create a remediation task for policies with DeployIfNotExists and Modify effects
  definitions = var.assignment_enforcement_mode == true && var.skip_remediation == false && length(local.identity_type) > 0 ? (var.initiative.policy_definition_reference != [] && var.initiative.policy_definition_reference != null ? var.initiative.policy_definition_reference : []) : []
  definition_reference = {
    mg       = local.remediate.mg > 0 ? local.definitions : []
    sub      = local.remediate.sub > 0 ? local.definitions : []
    rg       = local.remediate.rg > 0 ? local.definitions : []
    resource = local.remediate.resource > 0 ? local.definitions : []
  }

  # evaluate outputs
  assignment = try(
    azurerm_management_group_policy_assignment.set[0],
    azurerm_subscription_policy_assignment.set[0],
    azurerm_resource_group_policy_assignment.set[0],
    azurerm_resource_policy_assignment.set[0],
  {})
  remediation_tasks = try(
    azurerm_management_group_policy_remediation.rem,
    azurerm_subscription_policy_remediation.rem,
    azurerm_resource_group_policy_remediation.rem,
    azurerm_resource_policy_remediation.rem,
  {})
}
