terraform {
  required_version = ">= 0.15"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.54.0"
    }
    databricks = {
      source = "databrickslabs/databricks"
      version = "0.3.5"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-status-storage"
    storage_account_name = "terraformstatusstorage"
    container_name       = "terraformcontainer"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = local.RESOURCE_GROUP_NAME
  location = var.LOCATION
  tags     = local.RESOURCE_GROUP_TAGS
}

resource "azurerm_storage_account" "adls" {
  name                     = local.DATA_LAKE_NAME
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
  tags                     = local.DATA_LAKE_TAGS
}

resource "azurerm_storage_container" "adls" {
  for_each             = toset(local.DATA_LAKE_CONTAINERS)
  name                 = each.key
  storage_account_name = azurerm_storage_account.adls.name
}

resource "azurerm_databricks_workspace" "adb" {
  name                = local.DATABRICKS_NAME
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "standard"
  tags                = local.DATABRICKS_TAGS
}

##############################
#  Databricks configuration  #
##############################

provider "databricks" {
  alias = "adb"

  azure_workspace_resource_id = azurerm_databricks_workspace.adb.id
}

resource "databricks_token" "pat" {
  provider = databricks.adb
  comment  = "Terraform Provisioning"
  // 1 day token
  lifetime_seconds = 86400
}

#############################
#       Mount storage       #
#############################

resource "databricks_secret_scope" "terraform" {
  provider                 = databricks.adb
  name                     = "application"
  initial_manage_principal = "users"
}

resource "databricks_secret" "service_principal_key" {
  provider     = databricks.adb
  key          = "service_principal_key"
  string_value = var.CLIENT_SECRET
  scope        = databricks_secret_scope.terraform.name
}

resource "databricks_azure_adls_gen2_mount" "containers" {
  provider               = databricks.adb
  for_each               = toset(local.DATA_LAKE_CONTAINERS)
  container_name         = each.value
  storage_account_name   = azurerm_storage_account.adls.name
  mount_name             = each.value
  tenant_id              = data.azurerm_client_config.current.tenant_id
  client_id              = data.azurerm_client_config.current.client_id
  client_secret_scope    = databricks_secret_scope.terraform.name
  client_secret_key      = databricks_secret.service_principal_key.key
  initialize_file_system = true
}

######################
#  Output variables  #
######################

output "DATABRICKS_HOST" {
  value = "https://${azurerm_databricks_workspace.adb.workspace_url}"
}

output "DATABRICKS_TOKEN" {
  value     = databricks_token.pat.token_value
  sensitive = true
}
