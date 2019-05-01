provider "aws" {
  region     = "${var.aws_region}"
}

data "aws_route53_zone" "zone" {
  name         = "${var.dns_zone_name}"
  private_zone = true
}

resource "aws_route53_record" "record" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${var.name}.${data.aws_route53_zone.zone.name}"
  type    = "CNAME"
  records = ["${var.ips}"]
  ttl     = "900"
}