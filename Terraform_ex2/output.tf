output "instance_id" {
  description = "ID of the single web instance"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "Public IP of web instance"
  value       = aws_instance.web.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of web instance"
  value       = aws_instance.web.public_dns
}