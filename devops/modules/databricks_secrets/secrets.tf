terraform {
  required_providers {
      databricks = {
        source = "databrickslabs/databricks"
        version = "=0.3.2"
      }
  }
}

resource "databricks_secret_scope" "terraform" {
    name                     = "application"
    initial_manage_principal = "manage"
}

resource "databricks_secret" "service_principal_key" {
    key          = "service_principal_key"
    string_value = var.service_principal_key
    scope        = databricks_secret_scope.terraform.name
}