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

variable "security_groups" {
  description = "Security group(s) for the instances"
}

variable "elb" {
  description = "Name of the ELB the cluster should attach to"
}


variable "availability_zones" {
  type        = "list"
  description = "Zones we want the ebs to be available in"
}

variable "ebs_encrypted" {
  description = "If true, will encrpt EBS"
}

variable "ebs_storage_size" {
  description = "Size of drive in GiBs for EBS"
}

variable "ebs_type" {
  description = "The type of EBS volume"
}