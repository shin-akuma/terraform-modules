run "plan_without_lock" {
  command = plan
}

run "plan_with_readonly_lock" {
  command = plan

  variables {
    resource_lock_level = "ReadOnly"
  }
}
