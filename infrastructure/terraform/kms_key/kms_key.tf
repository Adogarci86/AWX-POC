provider "aws" {
  region = "${var.region}"
}

resource "aws_kms_key" "create_kms_key" {
  description             = "${var.description}"
  deletion_window_in_days = "${var.deletion_window_in_days}"
  key_usage               = "${var.key_usage}"
  is_enabled              = "${var.is_enabled}"
  enable_key_rotation     = "${var.enable_key_rotation}"
  tags                    = "${merge(var.tags)}"
}

resource "aws_kms_alias" "create_kms_key_alias" {
  depends_on = ["aws_kms_key.create_kms_key"]

  name          = "alias/${var.alias}"
  target_key_id = "${aws_kms_key.create_kms_key.key_id}"
}