provider "aws" {
  region     = "${var.aws_region}"
}
 
resource "aws_db_parameter_group" "default" {
  name = "${var.name}"
  family = "mysql5.7"
  tags = "${var.tags}"
  parameters = ["${var.db_parameters}"]
} 

