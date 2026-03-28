output "alb_dns_name" {
    value = aws_lb.public_alb.dns_name
    description = "DNS name of the Application Load Balancer"
}

output "lb_target_group_arn" {
    value = aws_lb_target_group.alb_target_group.arn
    description = "ARN for the load balancer target group"
}