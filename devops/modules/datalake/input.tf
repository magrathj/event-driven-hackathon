variable "prefix" {
    type = string
}
variable "resource_group" {
    type = string
}
variable "resource_group_name" {
    type = string
}
variable "location" {
    type = string
}
variable "account_tier" {
    type = string
    default = "Standard"
}
variable "account_replication_type" {
    type = string
    default = "LRS"
}
variable "account_kind" {
    type = string
    default = "StorageV2"
}
variable "is_hns_enabled" {
    type = string
    default = "true"
}