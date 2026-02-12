output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.main.endpoint
}

output "rds_port" {
  description = "RDS Port for MySQL"
  value       = aws_db_instance.main.port
}

output "rds_dbi" {
  description = "RDS DBI resource ID"
  value       = aws_db_instance.main.id
}

output "rds_master_secret_arn" {
  description = "ARN of RDS Master Secret"
  value       = aws_db_instance.main.master_user_secret[0].secret_arn
}

output "rds_proxy_prx_id" {
  description = "RDS Proxy ID"
  value       = local.rds_proxy_prx_id
}

output "rds_proxy_arn" {
  description = "RDS Proxy ARN"
  value       = aws_db_proxy.devdb_proxy.arn
}

output "rds_proxy_endpoint" {
  description = "RDS Proxy ARN"
  value       = aws_db_proxy.devdb_proxy.endpoint
}