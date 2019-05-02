variable "aws_region" {
  description = "AWS Default Region"
  default     = "us-west-2"
}

variable "sg_name" {
  description = "Security Group Name"
  type        = "string"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = "string"
}
