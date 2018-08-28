output "app_vpc_id" {
  value = "${local.app_vpc_id}"
}

output "app_subnet_id" {
  value = "${local.app_subnet_id}"
}

output "app_instance_security_group" {
  value = "${aws_security_group.default.id}"
}
