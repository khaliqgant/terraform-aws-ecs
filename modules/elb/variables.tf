variable "name" {
  description = "Name of the load balancer"
}

variable "subnet_id" {
  type        = "list"
  description = "The number of ec2 instances to run in the ECS Cluster"
}

variable "security_group" {
  description = "Security group for the ELB"
}

variable "healthy_threshold" {
  description = "Minimum number of instances alive for the elb to be considered healthy"
}

variable "unhealthy_threshold" {
  description = "Minimum number of instances alive for the elb to be considered unhealthy"
}

variable "timeout" {
  description = "Time for the ELB to wait until to try to connect"
}

variable "interval" {
  description = "Interval for the elb to check against its instances"
}

variable "port" {
  description = "Port for the ELB to check"
}

variable "instance_port" {
  description = "Port for the lb to hit when checking the instance"
}

variable "protocol" {
  description = "Protocol for the ELB to check"
}

variable "health_check_path" {
  description = "Path for the ELB to check for a healthy response"
}

# optional
variable "is_internal" {
  description = "If the ELB is internal or not"
}
