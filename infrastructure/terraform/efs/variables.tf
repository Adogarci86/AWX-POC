variable "aws_region" {}

variable "instance_name" {
  description = "Used to populate the Name tag. This is done in main.tf"
}

variable "subnet_id" {
  description = "The VPC subnet the instance(s) will go in"
  type        = "list"
}

variable "tags" {
  description = "A map of tags to add"
  type        = "map"
}

variable "security_groups" {
  type = "list"
}