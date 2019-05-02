provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_security_group" "sg_db" {
  name        = "${var.db_sg_name}"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_cr}"]
    description = "Cross-region CIDR Blocks"
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_ma}"]
    description = "MA pod CIDR Blocks"
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_pod}"]
    description = "Current POD CIDR Blocks"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.db_sg_name}"
    APPLICATION_ENVIRONMENT = "${var.application_environment}"
    APPLICATION_ROLE = "${var.application_role}"
    BUSINESS_ENTITY = "${var.business_entity}"
    BUSINESS_UNIT = "${var.business_unit}"
    DOMAIN = "${var.domain}"
    POD_ENVIRONMENT = "${var.pod_environment}"
    OWNER_EMAIL = "${var.owner_email}"
    POD_NAME = "${var.pod_name}"
  }
}
