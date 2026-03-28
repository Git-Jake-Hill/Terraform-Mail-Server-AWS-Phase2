variable "vpc_id" {
  description = "VPC ID to associate the ALB with"
  type        = string
}

variable "subnet_ids" {
  description = "The ID of the subnets to launch the ALB in"
  type        = list(string)
}

variable "security_groups" {
  description = "The ID of the security groups to associate with the ALB"
  type        = list(string)
}
