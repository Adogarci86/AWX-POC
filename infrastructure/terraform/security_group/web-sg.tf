provider "aws" {
  region = "${aws_region}"
}

resource "aws_security_group" "sg_web" {
  name        = "${web_sg_name}"
  description = "Allow all inbound traffic"
  vpc_id      = "${vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["${cidr_blocks_ma}"]
    description = "HTTPS Port"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["${cidr_blocks_pod}"]
    description = "HTTPS Port"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    self        = true
    description = "HTTPS Port"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "${web_sg_name}"
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
