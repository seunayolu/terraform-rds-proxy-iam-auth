variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "rds_proxy_prx_id" {
  description = "RDS Proxy ID"
  type        = string
}

variable "rds_dbi" {
  description = "RDS resource id"
  type        = string
}