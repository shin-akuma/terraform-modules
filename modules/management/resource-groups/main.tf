resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.location
  tags     = var.tags
}

resource "azurerm_management_lock" "this" {
  for_each = var.resource_lock_level != "None" ? { "${var.resource_lock_level}" = var.resource_lock_level } : {}

  name       = var.resource_lock_level
  scope      = azurerm_resource_group.this.id
  lock_level = var.resource_lock_level
  notes      = var.resource_lock_level == "CanNotDelete" ? "Cannot delete resource or child resources." : "Cannot modify the resource or child resources."
}
