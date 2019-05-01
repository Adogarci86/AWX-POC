provider "aws" {
  region     = "${var.aws_region}"
}

resource "aws_elb_attachment" "attach_ec2" {
  elb      = "${var.elb_id}"
  instance = "${var.ec2_instance_id}"
}

variable "aws_region" {}

variable "ec2_instance_id" {
  type = "string"
}

variable "elb_id" {
  type = "string"
}