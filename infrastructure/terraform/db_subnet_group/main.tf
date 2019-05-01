provider "aws" {
  region     = "${var.aws_region}"
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.name}"
  subnet_ids = "${var.subnet_ids}"

  tags       = "${var.tags}"
}