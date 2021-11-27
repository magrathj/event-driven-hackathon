resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-${var.resource_group_name}"
  location = var.location
  tags     = {environment = "${var.prefix}"}
}