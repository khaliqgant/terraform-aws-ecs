# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN ECS SERVICE TO RUN A LONG-RUNNING ECS TASK
# @see https://www.terraform.io/docs/providers/aws/r/ecs_service.html
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_ecs_service" "service" {
  name            = "${var.name}"
  cluster         = "${var.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.task.arn}"
  desired_count   = "${var.desired_count}"

  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"
  deployment_maximum_percent         = "${var.deployment_maximum_percent}"
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

