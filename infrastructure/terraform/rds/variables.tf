variable "allocated_storage" {
  description = ""
  type = "string"
  default = "300"
}

variable "auto_minor_version_upgrade" {}

variable "aws_region" {
  description = "AWS Default Region"
  default = "us-west-2"
}

variable "backup_retention_period" {
  description = "The days to retain backups for."
  type = "string"
  default = "30"
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled."
  type = "string"
  default = "09:46-10:16"
}

variable "db_subnet_group_name" {
  description = ""
  type = "string"
}

variable "engine_version" {
  description = ""
  type = "string"
  default = "5.7.19"
}

variable "identifier" {
  description = "The name of the RDS instance. It forces new resource. If omitted, Terraform will assign a random, unique identifier."
  type = "string"
}

variable "instance_class" {
  description = ""
  type = "string"
}

variable "iops" {
  default = ""
}

variable "kms_key_id" {
  default = ""
}

variable "maintenance_window" {
  description = "The window to perform maintenance in."
  type = "string"
  default = "Sat:00:00-Sat:03:00"
}

variable "multi_az" {
  description = "If the RDS instance is multi AZ enabled."
  type = "string"
  default = "false"
}

variable "OWNEREMAIL" {
  description = "Set the owner of this AWS instance"
  type = "string"
  default = "jstang@informatica.com"
}

variable "parameter_group_name" {
  description = ""
  type = "string"
}

variable "password" {
  description = ""
  type = "string"
}

variable "securitygroups" {
  description = "VPC security group ids associated with new db instance"
  type = "list"
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted."
  type = "string"
  default = "false"
}

variable "storage_encrypted" {
  default = "false"
}

variable "storage_type" {
  default = "gp2"
}

variable "username" {
  description = ""
  type = "string"
}

variable "tags" {
  type = "map"
}
