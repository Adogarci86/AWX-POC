variable "aws_region" {
  description = "AWS Default Region"
  default     = "us-west-2"
}

variable "cidr_blocks_cr" {
  description = "CIDR block used by cross-region calls"
}

variable "cidr_blocks_ma" {
  description = "CIDR block used by ma-pod"
}

variable "cidr_blocks_pod" {
  description = "CIDR block used by current pod"
}

variable "db_sg_name" {
  description = "Security Group Name"
  type        = "string"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = "string"
}
