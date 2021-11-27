variable "ENVIRONMENT" {
  description = "environment name"
  type        = string
  default     = null
}
variable "LOCATION" {
  description = "resource location e.g. northeurope"
  type        = string
  default     = "northeurope"
}
variable "GLOBAL_TAGS" {
  description = "tags common to all deployed resources"
  type        = map
  default     = {}
}
variable "CLIENT_SECRET" {
  description = "service principal secret"
  type        = string
  sensitive   = true
}

locals {
  ENVIRONMENT = coalesce(var.ENVIRONMENT, "${terraform.workspace}")
  GLOBAL_TAGS = merge(var.GLOBAL_TAGS, {
    CreatedBy   = "Terraform",
    Environment = local.ENVIRONMENT,
  })

  RESOURCE_GROUP_NAME = "rg-terraform-deploy-${local.ENVIRONMENT}"
  RESOURCE_GROUP_TAGS = local.GLOBAL_TAGS

  DATA_LAKE_NAME = "${local.ENVIRONMENT}daiadls"
  DATA_LAKE_TAGS = local.GLOBAL_TAGS
  DATA_LAKE_CONTAINERS = ["landing", "bronze", "silver", "gold"]

  DATABRICKS_NAME = "${local.ENVIRONMENT}daiadb"
  DATABRICKS_TAGS = local.GLOBAL_TAGS
}
