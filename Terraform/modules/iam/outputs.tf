output "ec2_instance_profile_name" {
  description = "EC2 Instance profile"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}

output "rds_proxy_role_arn" {
  description = "RDS Proxy IAM Role"
  value       = aws_iam_role.rds_proxy_role.arn
}