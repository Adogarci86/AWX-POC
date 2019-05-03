variable "aws_region" {}

variable "db_subnet_group_name" {
  type = "string"
}

variable "db_subnet_ids" {
  type = "list"
}

variable "application_environment" {
  description = "application_environment"
  type        = "string"
}

variable "application_role" {
  description = "application_role"
  type        = "string"
}

variable "business_entity" {
  description = "business_entity"
  type        = "string"
}

variable "business_unit" {
  description = "business_unit"
  type        = "string"
}

variable "domain" {
  description = "domain"
  type        = "string"
}

variable "pod_environment" {
  description = "pod_environment"
  type        = "string"
}

variable "owner_email" {
  description = "owner_email"
  type        = "string"
}

variable "pod_name" {
  description = "pod_name"
  type        = "string"
}
