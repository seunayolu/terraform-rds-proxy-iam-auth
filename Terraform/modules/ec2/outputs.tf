output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.node_app_instance.id
}

output "instance_private_ip" {
  description = "EC2 Instance Public IP"
  value       = aws_instance.node_app_instance.private_ip
}

output "instance_ami" {
  description = "EC2 Instance AMI"
  value       = data.aws_ami.ubuntu.id
}