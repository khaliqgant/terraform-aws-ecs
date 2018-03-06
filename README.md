Terraform ECS Provisioning
==================

# Overview
* This module allows an ECS cluster and service to be spun up within a new VPC
and served using a load balancer. You'll need to have a keypair (variable: aws_key_pair)
and a [profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-multiple-profiles.html) 
set in your aws config (variable: aws_profile)
* The entry point is main.tf and it processes the variables and goes through
each module setting up what you need for the cluster.
* All configuration is handled in the top level variables.tf file for
organizational purposes and can be set via an `*.tfvars` file. An
example app.tfvars file is included in this repo. Dynamically filled in 
variables are nested in the individual modules

# Commands
* To see how this would work without actually spinning anything up you can run:
```
# This only needs to be run once
terraform init

# This shows what would happen and applies the variables set in the app.tfvars file
terraform plan -var-file="app.tfvars"
```
* To run:
```
terraform apply -var-file="app.tfvars"
```
* To destroy
```
terraform destroy -var-file="app.tfvars"
```

# Optional Params
* There are some optional parameters the most notable are `provided_vpc_id` and
`provided_subnets`. If you have an existing VPC set up and subets associated with it
you can pass those in. Otherwise a new VPC and subnets will be created. If you have
values for those variables set them in your custom `tfvars` file like so:
```
provided_vpc_id = "vpc-1a23b4cd"
provided_subnets = ["subnet-ab1c234d", "subnet-ab1c234e", "subnet-ab1c234f"]
```
* Both must be provided if you want to set the variables. Otherwise the provisioning
will fail.

# Deploying
* I would recommend using something like Jenkins to deploy. You'll want to
authenticate to aws and ecr, publish the built images to ECR then push
a task definition
* Part of this provisioning process pushes a task definition but that is meant
to be replaced and that is just a placeholder

# Additional Information
* [Terraform Docs](https://www.terraform.io/docs/index.html)
* [ECS](https://aws.amazon.com/ecs/)
* [Terraform tips & tricks: loops, if-statements, and gotchas](https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9)
* [Setup a container cluster on aws with terraform part 2-provision a cluster](http://blog.shippable.com/setup-a-container-cluster-on-aws-with-terraform-part-2-provision-a-cluster)

# Inspiration/References
* [Provision ECS Cluster Terraform](https://github.com/devops-recipes/provision-ecs-cluster-terraform) - "Shippable sample that demonstrates how to provision and deprovision a VPC on AWS using terraform CLI"
* [infrastructure-as-code](https://github.com/brikis98/infrastructure-as-code-talk) - "Sample code for the talk "Infrastructure-as-code: running microservices on AWS with Docker, ECS, and Terraform"
* [koding/terraform](https://github.com/koding/terraform/blob/master/examples/aws-elb/main.tf) - "ELB with stickiness Example"
* [arminc/terraform-ecs](https://github.com/arminc/terraform-ecs) - "AWS ECS terraform module"
* [terraform-aws-ecs-cluster](https://github.com/infrablocks/terraform-aws-ecs-cluster) - "Terraform module for building an ECS cluster in AWS"
