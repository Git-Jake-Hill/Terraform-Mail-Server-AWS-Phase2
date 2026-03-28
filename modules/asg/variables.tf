variable "lb_target_group_arn" {
    type = string
    description = "ARN for load balancer target group"
}

variable "instance_subnet_ids" {
  description = "The IDs of the subnets to launch instances in"
  type        = list(string)
}

variable "asg_launch_template_id" {
    description = "ASG launch template ID used to create EC2 instances"
    type = string
}