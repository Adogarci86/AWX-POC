provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_security_group" "sg_efs" {
  name        = "${var.efs_sg_name}"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_pod}"]
    description = "SSH Port"
  }
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_ma}"]
    description = "SSH Port"
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.efs_sg_name}"
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
