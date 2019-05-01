provider "aws" {
  region     = "${var.aws_region}"
}

resource "aws_efs_file_system" "efs" {
  creation_token = "${format("EFS-%s", var.instance_name)}"
  tags           = "${merge(var.tags,
                               map("NAME", var.instance_name),
                               map("Name", var.instance_name))}"
}

resource "aws_efs_mount_target" "efs" {
  depends_on      = ["aws_efs_file_system.efs"]
  file_system_id  = "${aws_efs_file_system.efs.id}"
  security_groups = "${var.security_groups}"
  subnet_id       = "${var.subnet_id[0]}"
}