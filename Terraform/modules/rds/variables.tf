variable "proxy_iam_role_arn" {
  description = "RDS Proxy IAM Role"
  type        = string
}

variable "proxy_security_group" {
  description = "RDS Proxy Security Group"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_iam_auth_user" {
  description = "DB IAM Auth User"
  type        = string
}

variable "db_engine" {
  description = "Database Engine Type"
  type        = string
}

variable "db_storage_type" {
  description = "Database Storage Type"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_storage_size" {
  description = "RDS storage size in GB"
  type        = number
}

variable "db_engine_version" {
  description = "RDS MySQL engine version"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for RDS"
  type        = list(string)
}

variable "rds_security_group" {
  description = "Security group ID for RDS"
  type        = set(string)
}