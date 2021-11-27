resource "azurerm_databricks_workspace" "main" {
  name                = "${var.prefix}-${var.workspace}"
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = var.sku
  tags                = {environment = "${var.prefix}"}
}