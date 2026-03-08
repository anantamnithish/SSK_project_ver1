
# Configure Terraform Backend for State Management in S3
terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-563184259844"
    key    = "ex_terraform.tfstate"
    region = "ap-south-2"
  }
}

# provider configuration lives in provider.tf; required_providers are defined in version.tf

# Lookup existing IAM instance profile if provided
data "aws_iam_instance_profile" "existing" {
  name = var.instance_profile_name
}

# Basic security group allowing SSH/HTTP
resource "aws_security_group" "instance_sg" {
  name        = "instance-sg"
  description = "Allow SSH and HTTP access"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance-security-group"
  }
}

# Single EC2 instance with lifecycle and user_data
resource "aws_instance" "web" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  iam_instance_profile   = data.aws_iam_instance_profile.existing.name
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              # Update all packages
              dnf update -y

              # Install Apache (httpd)
              dnf install -y httpd

              # Enable and start the service
              systemctl enable httpd
              systemctl start httpd

              # add a simple index.html
              echo "Hello from Terraform" > /var/www/html/index.html
              EOF

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = true
    #ignore_changes        = [tags]
  }

  tags = {
    Name        = "web-instance"
    environment = "Dev"
    project     = "Terraform_Examples"
  }
}
