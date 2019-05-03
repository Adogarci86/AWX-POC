provider "aws" {
  region     = "${var.aws_region}"
}

resource "aws_db_subnet_group" "default" {
  db_subnet_group_name       = "${var.db_subnet_group_name}"
  subnet_ids = "${var.db_subnet_ids}"

  tags {
    Name = "${var.db_subnet_group_name}"
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
