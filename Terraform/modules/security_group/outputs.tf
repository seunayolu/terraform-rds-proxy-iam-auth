output "rds_sg_id" {
  description = "RDS Security Group ID"
  value       = aws_security_group.rds_sg.id
}

output "rds_proxy_sg_id" {
  description = "RDS Proxy Security Group ID"
  value       = aws_security_group.rds_proxy_sg.id
}

output "ec2_sg_id" {
  description = "EC2 Instance Security Group ID"
  value       = aws_security_group.ec2_instance_sg.id
}

output "alb_sg_id" {
  description = "ALB Security Group"
  value       = aws_security_group.alb_security_group.id
}