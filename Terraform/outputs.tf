output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "rds_dbi" {
  description = "RDS DBI"
  value       = module.rds.rds_dbi
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

output "ec2_security_group" {
  description = "EC2 Security Group"
  value       = module.security_group.ec2_sg_id
}

output "rds_security_group" {
  description = "RDS Security Group"
  value       = module.security_group.rds_sg_id
}

output "rds_proxy_security_group" {
  description = "RDS Proxy Security Group"
  value       = module.security_group.rds_proxy_sg_id
}

output "rds_db_secret_name" {
  description = "RDS DB Name"
  value       = module.rds.rds_secret_name
}

output "secret_name" {
  description = "RDS Secret Name without the last 6 characters"
  value       = local.secret_name
}

output "rds_address" {
  description = "RDS Address"
  value       = module.rds.rds_address
}

output "ecr_repo_name" {
  description = "ECR Repository Name"
  value       = module.ecr.ecr_repo_name
}

output "registry" {
  description = "ECR Registry"
  value       = module.ecr.registry
}

# output "ec2_instance_profile_name" {
#   description = "RDS Proxy IAM Role ARN"
#   value       = module.iam.ec2_instance_profile_name
# }

# output "ec2_instance_id" {
#   description = "EC2 Instance ID"
#   value       = module.ec2.instance_id
# }

# output "ec2_instance_private_ip" {
#   description = "EC2 Instance Private IP"
#   value       = module.ec2.instance_private_ip
# }

# output "alb_security_group" {
#   description = "ALB Security Group"
#   value       = module.security_group.alb_sg_id
# }

# output "s3_bucket_name" {
#   description = "S3 Bucket Name"
#   value       = module.s3.bucket_name
# }

# output "s3_bucket_arn" {
#   description = "S3 Bucket ARN"
#   value       = module.s3.bucket_arn
# }

# output "alb_dns_name" {
#   description = "ALB DNS Endpoint"
#   value       = module.alb.alb_dns_name
# }

# output "alb_target_group_arn" {
#   description = "ALB Target Group ARN"
#   value       = module.alb.target_group_arn
# }