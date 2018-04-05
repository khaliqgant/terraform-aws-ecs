# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN ELB
# @see https://www.terraform.io/docs/providers/aws/r/elb.html
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_elb" "elb" {
  name                      = "${var.name}"
  subnets                   = ["${var.subnet_id}"]
  security_groups           = ["${var.security_group}"]
  cross_zone_load_balancing = true
  internal                  = "${var.is_internal}"

  health_check {
    healthy_threshold   = "${var.healthy_threshold}"
    unhealthy_threshold = "${var.unhealthy_threshold}"
    timeout             = "${var.timeout}"
    interval            = "${var.interval}"

    target = "HTTP:${var.instance_port}/${var.health_check_path}"
  }

  listener {
    instance_port     = "${var.instance_port}"
    instance_protocol = "${var.protocol}"
    lb_port           = "${var.port}"
    lb_protocol       = "${var.protocol}"
  }
}
