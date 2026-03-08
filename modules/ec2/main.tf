# AMI image
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# EC2 instance
resource "aws_instance" "email_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  iam_instance_profile   = aws_iam_instance_profile.email_server_profile.name
  vpc_security_group_ids = [var.security_group_id]

  user_data = templatefile("${path.module}/user_data_script.sh", {})
  depends_on = [ var.nat_gateway_id ]

  tags = {
    Name = "Ubuntu-Noble-2404-Email-Server"
  }
}

##############################
# SSM Session Manager access
##############################
# IAM role for SSM Session Manager access
resource "aws_iam_role" "ssm_role" {
  name = "ssm_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "ssmSessionManagerAccess"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Managed policy attachment for SSM Session Manager access
resource "aws_iam_role_policy_attachment" "ssm_role_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

}

# IAM instance profile to associate the role with the EC2 instance
resource "aws_iam_instance_profile" "email_server_profile" {
  name = "email_server_ssm_profile"
  role = aws_iam_role.ssm_role.name
}

