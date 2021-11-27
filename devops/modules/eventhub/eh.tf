resource "azurerm_eventhub_namespace" "main" {
  name                = "${var.prefix}-eventhub-namespace"
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = var.sku
  capacity            = var.capacity
  tags                = {environment = "${var.prefix}"}
}

resource "azurerm_eventhub" "main" {
  name                = "${var.prefix}-eventhub"
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = var.resource_group
  partition_count     = var.partition_count
  message_retention   = var.message_retention
}