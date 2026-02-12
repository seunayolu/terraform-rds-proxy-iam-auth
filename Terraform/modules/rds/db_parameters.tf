data "aws_region" "current" {}

resource "aws_ssm_parameter" "db_name" {
  name        = "/dev/database/dbname"
  type        = "String"
  value       = aws_db_instance.main.db_name
  description = "parameter for dev database name"
}

resource "aws_ssm_parameter" "db_enpoint" {
  name        = "/dev/database/endpoint"
  type        = "String"
  value       = aws_db_proxy.devdb_proxy.endpoint
  description = "parameter for dev database endpoint"
}

resource "aws_ssm_parameter" "db_username" {
  name        = "/dev/database/username"
  type        = "String"
  value       = var.db_iam_auth_user
  description = "DB user with AWSAuthentication Plugin"
}

resource "aws_ssm_parameter" "db_port" {
  name        = "/dev/database/port"
  type        = "String"
  value       = aws_db_instance.main.port
  description = "parameter for dev database port"
}

resource "aws_ssm_parameter" "db_region" {
  name        = "/dev/database/region"
  type        = "String"
  value       = data.aws_region.current.region
  description = "parameter for dev database region"
}