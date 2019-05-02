variable "aws_region" {
  description = "AWS Default Region"
  default     = "us-west-2"
}

variable "cidr_blocks_ma" {
  description = "CIDR block used by ma-pod"
}

variable "cidr_blocks_pod" {
  description = "CIDR block used by current pod"
  type        = "string"
}

variable "sg_name" {
  description = "Security Group Name"
  type        = "string"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = "string"
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
