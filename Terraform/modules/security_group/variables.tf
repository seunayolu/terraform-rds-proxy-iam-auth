variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "rds_port" {
  description = "RDS Port for MySQL"
  type        = string
}

variable "app_port" {
  description = "NodeJs Port"
  type        = string
}

variable "https_port" {
  description = "HTTPS Port"
  type        = string
}

variable "http_port" {
  description = "HTTPS Port"
  type        = string
}

variable "default_route" {
  description = "Default route"
  type        = string
}

variable "prefix_list" {
  description = "My Public IP address list"
  type        = string
}