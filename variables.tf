variable "app" {
  description = "Application name"
}

variable "instance_number" {
  description = "Number of instances to use in the ECS service"
}

variable "ssh_ips" {
  type        = "list"
  description = "List of IP addresses that can SSH into the instances"
}

variable "instance_type" {
  description = "EC2 instance type"
}

variable "cidr_block" {
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

variable "public_cidrs" {
  type        = "list"
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.3.0/24"]
  description = "Public CIDR block for the VPC"
}

variable "availability_zones" {
  type        = "list"
  description = "Availability zones for the app"
}

variable "destination_cidr_block" {
  description = "Specify all traffic to be routed either trough Internet Gateway or NAT to access the internet"
  default     = "0.0.0.0/0"
}

variable "aws_profile" {
  description = "AWS profile to use when provisioning the app. This is set in the ~/.aws directory"
}

variable "aws_region" {
  description = "AWS Region to place your app in"
}

variable "aws_key_pair" {
  description = "AWS key pair to use when creating your ecs instance"
}

variable "app_repositories" {
  type        = "list"
  description = "ECR repositories to create when making the app"
}

variable "app_ports" {
    type        = "list"
    description = "The ports for each repository in the app"
}

variable "app_memory_repositories" {
    type        = "list"
    description = "The memory required for each repository"
}

# optional parameters
variable "provided_vpc_id" {
  description = "Supply a VPC for the cluster to join"
  default     = ""
}

variable "provided_subnets" {
  type        = "list"
  description = "List of subnets for the cluster to attach to"
  default     = []
}

variable "volume_size" {
  default = "8"
  description = "Optional size of the volume created in the cluster"
}

variable "instance_cidr_blocks" {
  type    = "list"
  default = ["0.0.0.0/0"]
}

variable "public_ip_to_instances" {
  default = "false"
}

variable "custom_shell_command" {
  default = ""
}

variable "tags" {
  type    = "map"
  default = {}
  description = "Tag map that can be applied to a resource"
}
