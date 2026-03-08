

# Configure Terraform Backend for State Management in S3
terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-563184259844"
    key    = "terraform.tfstate"
    region = "ap-south-2"
  }
}

# EC2 Instance
resource "aws_instance" "Web" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = "Nithish-first"
  iam_instance_profile   = aws_iam_instance_profile.web_profile.name

  tags = {
    Name         = "Web-3"
    envinorment  = "Dev"
    Project_Name = "Terraform_Examples"
  }

  depends_on = [
    aws_iam_instance_profile.web_profile
  ]
}

# IAM role for EC2 to access S3 and SSM
resource "aws_iam_role" "ec2_role" {
  name = "ec2_s3_ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach managed policies for S3 and SSM
resource "aws_iam_role_policy_attachment" "s3_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance profile for EC2
resource "aws_iam_instance_profile" "web_profile" {
  name = "web_instance_profile"
  role = aws_iam_role.ec2_role.name
}

