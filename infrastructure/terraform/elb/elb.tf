provider "aws" {
  region     = "${var.aws_region}"
}

resource "aws_elb" "elb" {
  name                      = "${var.name}"
  subnets                   = "${var.subnets}"
  internal                  = "${var.elb_is_internal}"
  security_groups           = ["${var.elb_security_group}"]
  idle_timeout              = "${var.idle_timeout}"
  cross_zone_load_balancing = true
  instances                 = "${var.instances}"

  listener {
    instance_port      = "${var.backend_port}"
    instance_protocol  = "${var.backend_protocol}"
    lb_port            = "${var.lb_port}"
    lb_protocol        = "${var.lb_protocol}"
    ssl_certificate_id = "${var.ssl_certificate_id}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "${var.health_check_target}"
    interval            = 30
  }

  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

resource "aws_load_balancer_policy" "elb_proxy_policy" {
  count              = "${var.accept_proxy == "true" ? 1 : 0}"
  load_balancer_name = "${aws_elb.elb.name}"
  policy_name        = "${format("%s-policy", aws_elb.elb.name)}"
  policy_type_name   = "ProxyProtocolPolicyType"

  policy_attribute = {
    name  = "ProxyProtocol"
    value = "true"
  }
}

resource "aws_load_balancer_backend_server_policy" "elb_set_backend_policy" {
  count              = "${var.accept_proxy == "true" ? 1 : 0}"
  load_balancer_name = "${aws_elb.elb.name}"
  instance_port      = 443

  policy_names = [
    "${aws_load_balancer_policy.elb_proxy_policy.policy_name}",
  ]
}
