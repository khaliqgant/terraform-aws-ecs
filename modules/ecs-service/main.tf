# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN ECS SERVICE TO RUN A LONG-RUNNING ECS TASK
# We also associate the ECS Service with an ELB, which can distribute traffic across the ECS Tasks.
# @see https://www.terraform.io/docs/providers/aws/r/ecs_service.html
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_ecs_service" "service" {
  name            = "${var.name}"
  cluster         = "${var.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.task.arn}"
  desired_count   = "${var.desired_count}"
  iam_role        = "${aws_iam_role.ecs_service_role.arn}"

  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"
  deployment_maximum_percent         = "${var.deployment_maximum_percent}"

  load_balancer {
    elb_name       = "${var.elb_name}"
    container_name = "${element(var.repositories, 0)}"
    container_port = "${var.container_port}"
  }

  depends_on = ["aws_iam_role_policy.ecs_service_policy"]
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN ECS TASK TO RUN A DOCKER CONTAINER
# This creates a dummy task definition to allow only the cluster to be created.
# The task definition should be fully fleshed out on a deployment

# @see https://www.terraform.io/docs/providers/aws/d/ecs_task_definition.html
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_ecs_task_definition" "task" {
  family = "${var.name}"

  container_definitions = <<EOF
[${join(",", data.template_file.repos.*.rendered)}]
EOF
}

data "template_file" "repos" {
  count = "${length(var.repositories)}"

  template = <<EOF
{
"name": "${element(var.repositories, count.index)}",
"image": "${element(var.app_images, count.index)}",
"essential": true,
"memory": ${element(var.app_memory_repositories, count.index)},
"portMappings": [{
"containerPort": ${element(var.app_ports, count.index)},
"hostPort": ${element(var.app_ports, count.index)},
"protocol": "tcp"
}]
}
EOF
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN IAM ROLE FOR THE ECS SERVICE
#
# @see https://www.terraform.io/docs/providers/aws/d/iam_role.html
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "ecs_service_role" {
  name               = "${var.name}"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_service_role.json}"
}

# https://www.terraform.io/docs/providers/aws/d/iam_policy_document.html
data "aws_iam_policy_document" "ecs_service_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ATTACH IAM PERMISSIONS TO THE IAM ROLE
# This IAM Policy allows the ECS Service to communicate with EC2 Instances.
#
# @see https://www.terraform.io/docs/providers/aws/r/iam_role_policy.html
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "ecs_service_policy" {
  name   = "ecs-service-policy"
  role   = "${aws_iam_role.ecs_service_role.name}"
  policy = "${data.aws_iam_policy_document.ecs_service_policy.json}"
}

# https://www.terraform.io/docs/providers/aws/d/iam_policy_document.html
data "aws_iam_policy_document" "ecs_service_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
    ]
  }
}
