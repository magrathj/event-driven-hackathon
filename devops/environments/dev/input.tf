# Azure subscription vars
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

# Resource Group/Location
variable "location" {}
variable "resource_group" {}

# prefix for resource names
variable "prefix" {}

# Databricks workspace
variable "workspace" {}