resource "azurerm_application_insights" "main" {
  name                = "${var.prefix}-appinsights"
  location            = var.location
  resource_group_name = var.resource_group
  application_type    = var.application_type
}