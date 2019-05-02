provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_security_group" "sg_monitor" {
  name        = "${var.monitor_sg_name}"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_nagios}"]
    description = "Nagios MySQL Port"
  }

  ingress {
    from_port   = 5666
    to_port     = 5666
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_nagios}"]
    description = "Nagios Server Port"
  }

  ingress {
    from_port   = 8301
    to_port     = 8301
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_pod}", "${var.cidr_blocks_ma}"]
    description = "Consul TCP Port"
  }

  ingress {
    from_port   = 8301
    to_port     = 8301
    protocol    = "UDP"
    cidr_blocks = ["${var.cidr_blocks_pod}", "${var.cidr_blocks_ma}"]
    description = "Consul UDP Port"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.monitor_sg_name}"
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
