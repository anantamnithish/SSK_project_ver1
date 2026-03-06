

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
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = "Nithish-first"

  tags = {
    Name         = "Web-2"
    envinorment  = "Dev"
    Project_Name = "Terraform_Examples"
  }
}