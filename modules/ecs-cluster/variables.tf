variable "name" {
  description = "Name of the ECS Cluster"
}

variable "instance_size" {
  description = "The number of ec2 instances to run in the ECS Cluster"
}

variable "instance_type" {
  description = "Type of instance to run in the Cluster"
}

variable "key_pair_name" {
  description = "Name of the key pair to use for each instance"
}

variable "subnet_id" {
  type        = "list"
  description = "The subnet IDs in which to deploy the EC2 Instances of the ECS Cluster."
}

variable "security_group" {
  description = "Security group for the instances"
}

variable "elb" {
  description = "Name of the ELB the cluster should attach to"
}

variable "volume_size" {
  description = "Optional size of the volume created in the cluster"
}
