run "plan_with_endpoints_disabled" {
  command = plan

  assert {
    condition     = length(output.managed_private_endpoints_created) == 0
    error_message = "Expected no managed private endpoints when creation is disabled."
  }
}

run "plan_with_both_endpoints_enabled" {
  command = plan

  variables {
    create_managed_private_endpoints   = true
    enable_adls_managed_endpoint       = true
    enable_databricks_managed_endpoint = true
  }

  assert {
    condition     = length(output.managed_private_endpoints_created) == 2
    error_message = "Expected two managed private endpoints when both endpoint flags are enabled."
  }

  assert {
    condition     = contains(output.managed_private_endpoints_created, "pe-pvw-placeholder-adls")
    error_message = "Expected ADLS managed private endpoint name in output."
  }

  assert {
    condition     = contains(output.managed_private_endpoints_created, "pe-pvw-placeholder-databricks")
    error_message = "Expected Databricks managed private endpoint name in output."
  }
}
