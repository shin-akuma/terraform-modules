resource "azurerm_management_lock" "this" {
  for_each = var.locks

  name       = "${each.value.resource_name}-lck"
  scope      = each.value.resource_id
  lock_level = each.value.kind
  notes      = each.value.kind == "CanNotDelete" ? "Cannot delete the resource or its child resources." : "Cannot delete or modify the resource or its child resources."
}
