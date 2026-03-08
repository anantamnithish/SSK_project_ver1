# Terraform Playbook: EC2 Instance with IAM Roles for S3 & SSM

This guide walks you through creating an AWS EC2 instance that has permissions for Amazon S3 and AWS Systems Manager (SSM) using Terraform. The configuration uses `depends_on` to ensure IAM resources are fully created before the instance.

## 🔧 Resources Defined

- **IAM Role** (`aws_iam_role.ec2_role`) with trust policy for EC2
- **Managed policy attachments** for:
  - `AmazonS3FullAccess`
  - `AmazonSSMManagedInstanceCore`
- **IAM Instance Profile** (`aws_iam_instance_profile.web_profile`)
- **EC2 Instance** (`aws_instance.Web`) with `iam_instance_profile` set

The EC2 resource includes a `depends_on` block to explicitly depend on the instance profile, guaranteeing Terraform applies the role and attachments first.

## 🛠 Example `main.tf` Snippet

```hcl
# (backend configuration omitted for brevity)

resource "aws_iam_role" "ec2_role" {
  name = "ec2_s3_ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "web_profile" {
  name = "web_instance_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "Web" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = "Nithish-first"
  iam_instance_profile   = aws_iam_instance_profile.web_profile.name

  tags = {
    Name         = "Web-2"
    envinorment  = "Dev"
    Project_Name = "Terraform_Examples"
  }

  depends_on = [ aws_iam_instance_profile.web_profile ]
}
```

> **Note:** `depends_on` is usually not required if the dependency chain is explicit via references (e.g. using `iam_instance_profile = aws_iam_instance_profile.web_profile.name`). However, it's demonstrated here to explicitly enforce ordering.

## ✅ Usage Steps

1. Ensure AWS provider block is configured (not shown above).
2. Run `terraform init` to initialize the backend and provider.
3. Run `terraform plan` to review changes.
4. Apply with `terraform apply` and confirm.

The instance will be created only after the role, attachments, and profile are available.

## 📝 Variables

- `ami`: AMI ID for the instance.
- `instance_type`: EC2 instance type (defaults to `t3.micro`).

You can override these in a `terraform.tfvars` file or via command line.

---

Feel free to adapt the policy attachments or add inline policies as needed. This playbook can serve as a template for any EC2 instance that requires IAM credentials for AWS services.