provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_security_group" "sg_app" {
  name        = "${var.app_sg_name}"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_pod}"]
    description = "Another Kafka Port"
  }

  ingress {
    from_port   = 2888
    to_port     = 3888
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_pod}"]
    description = "Zookeeper Ports"
  }

  ingress {
    from_port   = 9012
    to_port     = 9012
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_pod}"]
    description = "SaaS JSF Port"
  }

  ingress {
    from_port   = 9089
    to_port     = 9092
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_pod}", "${var.cidr_blocks_ma}"]
    description = "Kafka Ports"
  }

    ingress {
    from_port   = 16000
    to_port     = 16150
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_pod}", "${var.cidr_blocks_ma}"]
    description = "Micro Services Ports"
  }

  ingress {
    from_port   = 16529
    to_port     = 16529
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_pod}"]
    description = "Auditlog-service Port"
  }

  ingress {
    from_port   = 16539
    to_port     = 16539
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_pod}"]
    description = "Autoscaler-service Port"
  }

  ingress {
    from_port   = 18055
    to_port     = 18055
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_pod}", "${var.cidr_blocks_ma}"]
    description = "MFTSaaS Port"
  }

  ingress {
    from_port   = 20023
    to_port     = 20023
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_pod}", "${var.cidr_blocks_ma}"]
    description = "CCI Port"
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    self            = "true"
    description     = "Allowing All Traffic from Same Security Group"
  }

  ingress {
    from_port   = 21000
    to_port     = 21100
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_pod}", "${var.cidr_blocks_ma}"]
    description = "HTTP check for HAproxy"
  }

  ingress {
    from_port   = 19066
    to_port     = 19066
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_pod}", "${var.cidr_blocks_ma}"]
    description = "HTTP check for HAproxy"
  }

  ingress {
    from_port   = 21443
    to_port     = 21443
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_pod}", "${var.cidr_blocks_ma}"]
    description = "HTTP check for HAproxy"
  }

  ingress {
    from_port   = 21529
    to_port     = 21529
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_pod}", "${var.cidr_blocks_ma}"]
    description = "HTTP check for HAproxy"
  }

  ingress {
    from_port   = 21539
    to_port     = 21539
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr_blocks_pod}", "${var.cidr_blocks_ma}"]
    description = "Auditlog-service Port"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.app_sg_name}"
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
