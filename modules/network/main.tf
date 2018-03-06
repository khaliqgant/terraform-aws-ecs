# https://www.terraform.io/docs/providers/aws/r/vpc.html
resource "aws_vpc" "default" {
  count                            = "${var.provided_vpc_id ==  "" ? 1 : 0}"
  cidr_block                       = "${var.cidr_block}"
  assign_generated_ipv6_cidr_block = true
}

# https://www.terraform.io/docs/providers/aws/r/internet_gateway.html
resource "aws_internet_gateway" "igw" {
  count  = "${var.provided_vpc_id ==  "" ? 1 : 0}"
  vpc_id = "${aws_vpc.default.id}"
}

# Allow for a conditional vpc to be set
locals {
  # See Note: https://github.com/coreos/tectonic-installer/blob/master/modules/aws/vpc/vpc.tf#L17
  # And Issue: https://github.com/hashicorp/terraform/issues/11566
  app_vpc_id = "${var.provided_vpc_id == "" ? join(" ", aws_vpc.default.*.id) : var.provided_vpc_id }"
}

# https://www.terraform.io/docs/providers/aws/d/subnet.html
# Multiple subets example: https://github.com/devops-recipes/provision-ecs-cluster-terraform/blob/master/provision-cluster/vpc.tf#L23
resource "aws_subnet" "app_subnet" {
  count                   = "${length(var.provided_subnets) > 0 ? 0 : length(var.cidrs)}"
  vpc_id                  = "${local.app_vpc_id}"
  cidr_block              = "${element(var.cidrs, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true
}

# https://www.terraform.io/docs/providers/aws/d/route_table.html
resource "aws_route_table" "subnet" {
  count  = "${length(var.provided_subnets) > 0 ? 0 : length(var.cidrs)}"
  vpc_id = "${local.app_vpc_id}"
}

# https://www.terraform.io/docs/providers/aws/r/route_table_association.html
resource "aws_route_table_association" "public-rtb" {
  count          = "${length(var.provided_subnets) > 0 ? 0 : length(var.cidrs)}"
  subnet_id      = "${element(aws_subnet.app_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.subnet.*.id, count.index)}"
}

# https://www.terraform.io/docs/providers/aws/r/route.html
resource "aws_route" "public_igw_route" {
  count                  = "${length(var.provided_subnets) > 0 ? 0 : length(var.cidrs)}"
  route_table_id         = "${element(aws_route_table.subnet.*.id, count.index)}"
  gateway_id             = "${aws_internet_gateway.igw.id}"
  destination_cidr_block = "${var.destination_cidr_block}"
}

# Allow for conditional subnets to be set
locals {
  # See Issue: https://github.com/hashicorp/terraform/issues/12453
  app_subnet_id = ["${split(",", length(var.provided_subnets) > 0 ? join(",", var.provided_subnets) : join(",", aws_subnet.app_subnet.*.id))}"]
}

# https://www.terraform.io/docs/providers/aws/d/security_group.html
resource "aws_security_group" "default" {
  name   = "${var.name}-security-group"
  vpc_id = "${local.app_vpc_id}"

  # SSH access from specified users
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${var.app_user_ips}"
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "tcp"

    cidr_blocks = [
      "${var.cidr_block}",
    ]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# https://www.terraform.io/docs/providers/aws/d/security_group.html
resource "aws_security_group" "elb" {
  name = "${var.name}-security-group-elb"

  vpc_id = "${local.app_vpc_id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
