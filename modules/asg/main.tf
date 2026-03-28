resource "aws_autoscaling_group" "asg" {
    desired_capacity = 2
    min_size = 1
    max_size = 3
    vpc_zone_identifier = var.instance_subnet_ids

    launch_template {
      id = var.asg_launch_template_id
      version = "$Latest"
    }

    target_group_arns = [var.lb_target_group_arn]
}