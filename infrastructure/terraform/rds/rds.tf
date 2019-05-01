provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_db_instance" "default" {
  allocated_storage       = "${var.allocated_storage}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  backup_retention_period = "${var.backup_retention_period}"
  backup_window           = "${var.backup_window}"
  db_subnet_group_name    = "${var.db_subnet_group_name}"
  engine                  = "mysql"
  engine_version          = "${var.engine_version}"
  identifier              = "${var.identifier}"
  instance_class          = "${var.instance_class}"
  iops                    = "${var.iops}"
  kms_key_id              = "${var.kms_key_id}"
  maintenance_window      = "${var.maintenance_window}"
  multi_az                = "${var.multi_az}"
  parameter_group_name    = "${var.parameter_group_name}"
  password                = "${var.password}"
  skip_final_snapshot     = "${var.skip_final_snapshot}"
  storage_encrypted       = "${var.storage_encrypted}"
  storage_type            = "${var.storage_type}"
  username                = "${var.username}"
  vpc_security_group_ids  = "${var.securitygroups}"

  tags                    = "${merge(var.tags,
                               map("NAME", format("%s-rds", var.identifier)),
                               map("Name", format("%s-rds", var.identifier)))}"
}