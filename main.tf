# https://www.terraform.io/docs/providers/aws/index.html
provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.aws_region}"
}

module "network" {
  source = "./modules/network"

  name                   = "${var.app}-network"
  cidr_block             = "${var.cidr_block}"
  app_user_ips           = "${var.ssh_ips}"
  destination_cidr_block = "${var.destination_cidr_block}"
  availability_zones     = "${var.availability_zones}"
  cidrs                  = "${var.public_cidrs}"

  provided_vpc_id  = "${var.provided_vpc_id}"
  provided_subnets = "${var.provided_subnets}"

  instance_cidr_blocks = "${var.instance_cidr_blocks}"
  lb_cidr_blocks       = "${var.lb_cidr_blocks}"

  tags             = "${var.tags}"
  http_access_port = "${var.app_http_access_port}"
}

module "elb" {
  source = "./modules/elb"

  name = "${var.app}-elb"

  subnet_id      = "${module.network.app_subnet_id}"
  security_group = "${module.network.app_lb_security_group}"

  healthy_threshold   = "${var.lb_healthy_threshold}"
  unhealthy_threshold = "${var.lb_unhealthy_threshold}"
  timeout             = "${var.lb_timeout}"
  interval            = "${var.lb_interval}"
  port                = "${var.lb_port}"
  instance_port       = "${var.lb_instance_port}"
  health_check_path   = "${var.lb_health_check_path}"
  protocol            = "${var.lb_protocol}"
  is_internal         = "${var.lb_is_internal}"

  tags             = "${var.tags}"
}

module "ecs-cluster" {
  source = "./modules/ecs-cluster"

  name                   = "${var.app}-cluster"
  instance_size          = "${var.instance_number}"
  instance_type          = "${var.instance_type}"
  key_pair_name          = "${var.aws_key_pair}"
  volume_size            = "${var.volume_size}"
  public_ip_to_instances = "${var.public_ip_to_instances}"
  custom_shell_command   = "${var.custom_shell_command}"

  # Reference the network and elb module outputs
  subnet_id      = "${module.network.app_subnet_id}"
  security_group = "${module.network.app_instance_security_group}"
  elb            = "${module.elb.app_elb_name}"

  tags             = "${var.tags}"
}

# Custom ECR Image for each required
module "ecr-repositories" {
  source       = "./modules/ecr-repository/"
  repositories = "${var.app_repositories}"
}

module "ecs-service" {
  source = "./modules/ecs-service"

  name           = "${var.app}-service"
  ecs_cluster_id = "${module.ecs-cluster.app_ecs_cluster_id}"

  repositories = "${var.app_repositories}"

  app_images              = "${module.ecr-repositories.ecr_url}"
  app_memory_repositories = "${var.app_memory_repositories}"
  app_ports               = "${var.app_ports}"
  desired_count           = "${var.instance_number}"
  container_port          = "${var.lb_instance_port}"
  elb_name                = "${module.elb.app_elb_name}"
}
