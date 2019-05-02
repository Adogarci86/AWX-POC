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