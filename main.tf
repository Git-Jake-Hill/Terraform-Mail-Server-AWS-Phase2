data "aws_caller_identity" "current" {}

# Simple check to avoid deploying to the wrong AWS account
locals {
  expected_account_id = "851725300754" # Your sandbox account
}

resource "null_resource" "account_check" {
  lifecycle {
    precondition {
      condition     = data.aws_caller_identity.current.account_id == local.expected_account_id
      error_message = "Wrong AWS account! Expected ${local.expected_account_id}, got ${data.aws_caller_identity.current.account_id}"
    }
  }
}

provider "aws" {
  profile = "sandbox"
  region  = var.region
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_name = "mailpit-vpc"
}

module "security_groups" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source            = "./modules/ec2"
  subnet_id         = module.vpc.private_subnet_id
  security_group_id = module.security_groups.ec2_security_group_id
  nat_gateway_id    = module.vpc.nat_gateway_id
}

module "alb" {
  source          = "./modules/alb"
  subnet_ids      = module.vpc.public_subnet_ids
  security_groups = [module.security_groups.alb_security_group_id]
  vpc_id          = module.vpc.vpc_id
}

module "asg" {
  source                 = "./modules/asg"
  lb_target_group_arn    = module.alb.lb_target_group_arn
  instance_subnet_ids    = module.vpc.private_subnet_ids
  asg_launch_template_id = module.ec2.asg_launch_template_id
}

output "alb_url" {
  value       = "http://${module.alb.alb_dns_name}"
  description = "URL to access the mail server UI"
}