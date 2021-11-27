resource "azurerm_storage_account" "main" {
  name                     = "${var.prefix}storage${var.resource_group_name}"
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
  is_hns_enabled           = var.is_hns_enabled
  tags                     = {environment = "${var.prefix}"}
}
