output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "rds_dbi" {
  description = "RDS DBI"
  value       = module.rds.rds_dbi
}

output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = module.rds.rds_endpoint
}

output "rds_proxy_prx_id" {
  description = "Proxy ID"
  value       = module.rds.rds_proxy_prx_id
}

output "rds_proxy_arn" {
  description = "Proxy ID"
  value       = module.rds.rds_proxy_arn
}

output "rds_proxy_endpoint" {
  description = "RDS Endpoint"
  value       = module.rds.rds_proxy_endpoint
}

output "rds_master_secret_arn" {
  description = "RDS Master Secret ARN"
  value       = module.rds.rds_master_secret_arn
}

output "rds_proxy_iam_role_arn" {
  description = "RDS Proxy IAM Role ARN"
  value       = module.iam.rds_proxy_role_arn
}

output "ec2_instance_profile_name" {
  description = "RDS Proxy IAM Role ARN"
  value       = module.iam.ec2_instance_profile_name
}

output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = module.ec2.instance_id
}

output "ec2_instance_public_ip" {
  description = "EC2 Instance Public IP"
  value       = module.ec2.instance_public_ip
}