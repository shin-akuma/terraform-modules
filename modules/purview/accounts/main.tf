resource "azurerm_purview_account" "this" {
  name                        = var.name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  managed_resource_group_name = var.managed_resource_group_name
  tags                        = var.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_management_lock" "this" {
  for_each = var.resource_lock_level != "None" ? { "${var.resource_lock_level}" = var.resource_lock_level } : {}

  name       = var.resource_lock_level
  scope      = azurerm_purview_account.this.id
  lock_level = var.resource_lock_level
  notes      = var.resource_lock_level == "CanNotDelete" ? "Cannot delete resource or child resources." : "Cannot modify the resource or child resources."
}
