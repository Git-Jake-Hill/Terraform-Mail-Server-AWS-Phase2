output "asg_launch_template_id" {
  value = aws_launch_template.asg_template.id
  description = "Launch template ID for ASG"
}