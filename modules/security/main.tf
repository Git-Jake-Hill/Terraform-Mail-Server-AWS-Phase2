resource "aws_security_group" "alb_security_group" {
  name        = "mailpit_alb_sg"
  description = "Security group for the public ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name = "mailpit_alb_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_all_ipv4_ingress" {
  security_group_id = aws_security_group.alb_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "alb_allow_all_ipv4_egress" {
  security_group_id = aws_security_group.alb_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_security_group" "ec2_security_group" {
  name        = "mailpit_ec2_sg"
  description = "Only allow inbound traffic from ALB security group and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "mailpit_ec2_sg"
  }
}

# Allow inbound traffic from ALB security group to EC2
resource "aws_vpc_security_group_ingress_rule" "ec2_allow_alb_ipv4_ingress" {
  referenced_security_group_id = aws_security_group.alb_security_group.id
  security_group_id            = aws_security_group.ec2_security_group.id
  from_port                    = 8025
  ip_protocol                  = "tcp"
  to_port                      = 8025
}


resource "aws_vpc_security_group_egress_rule" "ec2_allow_all_ipv4_egress" {
  security_group_id = aws_security_group.ec2_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

