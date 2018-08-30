variable "name" {
  description = "The name to set for the Network based resources"
}

variable "app_user_ips" {
  description = "IP addresses allowed to SSH in"
  type        = "list"
}

variable "destination_cidr_block" {
  description = "Access for the CIDR Block"
}

variable "cidr_block" {
  description = "Base CIDR block for the VPC"
}

variable "cidrs" {
  type        = "list"
  description = "Public CIDRS for the subnet to use"
}

variable "availability_zones" {
  type        = "list"
  description = "Zones we want the network to be available in"
}

# Optional params, but both must be supplied if provided
variable "provided_vpc_id" {
  description = "Supply a VPC for the cluster to join"
}

variable "provided_subnets" {
  type        = "list"
}

variable "instance_cidr_blocks" {
  type        = "list"
  description = "CIDR block for each instance"
}

variable "lb_cidr_blocks" {
  type        = "list"
  description = "CIDR block for load balancer access"
}

variable "tags" {
  type        = "map"
  description = "Tag map that can be applied to a resource"
}

variable "http_access_port" {
  description = "Port to access the application"
}
