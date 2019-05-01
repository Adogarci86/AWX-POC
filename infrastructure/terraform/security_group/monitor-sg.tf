provider "aws" {
  region = "${aws_region}"
}

resource "aws_security_group" "sg_monitor" {
  name        = "${monitor_sg_name}"
  description = "Allow all inbound traffic"
  vpc_id      = "${vpc_id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["${cidr_blocks_nagios}"]
    description = "Nagios MySQL Port"
  }

  ingress {
    from_port   = 5666
    to_port     = 5666
    protocol    = "TCP"
    cidr_blocks = ["${cidr_blocks_nagios}"]
    description = "Nagios Server Port"
  }

  ingress {
    from_port   = 8301
    to_port     = 8301
    protocol    = "TCP"
    cidr_blocks = ["${cidr_blocks_pod}", "${cidr_blocks_ma}"]
    description = "Consul TCP Port"
  }

  ingress {
    from_port   = 8301
    to_port     = 8301
    protocol    = "UDP"
    cidr_blocks = ["${cidr_blocks_pod}", "${cidr_blocks_ma}"]
    description = "Consul UDP Port"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "${monitor_sg_name}"
    APPLICATION_ENVIRONMENT = "${application_environment}"
    APPLICATION_ROLE = "${application_role}"
    BUSINESS_ENTITY = "${business_entity}"
    BUSINESS_UNIT = "${business_unit}"
    DOMAIN = "${domain}"
    POD_ENVIRONMENT = "${pod_environment}"
    OWNER_EMAIL = "${owner_email}"
    POD_NAME = "${pod_name}"
  }
}
