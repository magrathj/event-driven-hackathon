terraform {
  required_version = ">= 0.14" 
  required_providers {
    databricks = {
      source = "databrickslabs/databricks"
      version = "=0.3.2"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.54.0"
    }
  }
  backend "local" {}
}

provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

data "azurerm_client_config" "current" {}

module "resource_group" {
  source              = "../../modules/resource_group"
  location            = var.location
  prefix              = var.prefix
  resource_group_name = var.resource_group
}

module "keyvault" {
  source              = "../../modules/key_vault"
  resource_group      = module.resource_group.resource_group_name
  location            = var.location
  prefix              = var.prefix
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
  resource_group_name = var.resource_group
}

module "eventhub" {
  source             = "../../modules/eventhub"
  resource_group     = module.resource_group.resource_group_name
  location           = var.location
  prefix             = var.prefix
}

module "datalake" {
  source              = "../../modules/datalake"
  resource_group      = module.resource_group.resource_group_name
  location            = var.location
  prefix              = var.prefix
  resource_group_name = var.resource_group
}

module "databricks" {
  source              = "../../modules/databricks"
  resource_group      = module.resource_group.resource_group_name
  location            = var.location
  prefix              = var.prefix
  workspace           = var.workspace
}

module "application_insights" {
  source              = "../../modules/application_insights"
  resource_group      = module.resource_group.resource_group_name
  location            = var.location
  prefix              = var.prefix
}

provider "databricks" {
  azure_workspace_resource_id = module.databricks.databricks_workspace_id
  azure_client_id             = var.client_id
  azure_client_secret         = var.client_secret
  azure_tenant_id             = var.tenant_id
}
