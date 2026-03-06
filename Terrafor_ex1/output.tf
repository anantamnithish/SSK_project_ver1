output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.Web.public_ip
}

output "instance_public_dns" {
  description = "The public DNS name of the EC2 instance"
  value       = aws_instance.Web.public_dns
}