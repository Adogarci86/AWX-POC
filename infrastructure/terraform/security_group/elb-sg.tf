provider "aws" {
  region = "${aws_region}"
}

resource "aws_security_group" "sg_elb" {
  name        = "${elb_sg_name}"
  description = "Allow all inbound traffic"
  vpc_id      = "${vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS Port"
  }

  ingress {
    from_port   = 5003
    to_port     = 5003
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "FileMaker name binding and transport TCP port"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "${elb_sg_name}"
    APPLICATION_ENVIRONMENT: "${application_environment}"
    APPLICATION_ROLE:  "${application_role}"
    BUSINESS_ENTITY: "${business_entity}"
    BUSINESS_UNIT: "${business_unit}"
    DOMAIN: "${domain}"
    POD_ENVIRONMENT: "${pod_environment}"
    OWNER_EMAIL: "${owner_email}"
    POD_NAME: "${pod_name}"
    AMI_ID: "${ami_id}"
  }
}
