variable "AMIIDQUERY" {
  default = ""
}

variable "ami_id" {
  description = "The AMI to use"
  default     = ""
}

variable "attach_volume" {}

variable "aws_region" {}

variable "chef_env_name" {}

variable "chef_repo_dir" {}

variable "chef_user" {}

variable "ebs_device_name" {
  default = "/dev/sdc"
}

variable "ebs_mount_point" {}

variable "ebs_volume_iops" {
  default = "100"
}

variable "ebs_volume_type" {
  default = "standard"
}

variable "ebs_volume_size" {
  default = ""
}

variable "ec2_user" {
  default = "ec2-user"
}

variable "efs_ip_address" {}

variable "enable_encrypted_ebs" {
  default = "false"
}

variable "iam_instance_profile" {
  description = "iam role to attach to the instance"
  default     = ""
}

variable "ics_user" {}

variable "instance_name" {
  description = "Used to populate the Name tag. This is done in main.tf"
}

variable "instance_type" {}

variable "kms_key_id" {
  default = ""
}

variable "key_name" {}

variable "latest_ami" {}

variable "monitoring" {
  default = "false"
}

variable "mount_efs" {
  default = "false"
}

variable "number_of_instances" {
  default = 1
}

variable "placement_group" {
  description = "placement group"
  default     = ""
}

variable "short_name" {}

variable "subnets" {
  type = "list"
}

variable "swap_memory" {}

variable "tags" {
  description = "A map of tags to add"
  type        = "map"
}

variable "user_key" {}

variable "vpc_security_group_ids" {
  description = "The VPC security group IDs"
  type        = "list"
}

variable "efs_mount_location" {
  default = "/data/shared_dir"
}
