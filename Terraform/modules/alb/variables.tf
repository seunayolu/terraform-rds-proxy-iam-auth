variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "loadbalancer_type" {
  description = "ELB Type"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for ALB"
  type        = list(string)
}

variable "alb_security_groups" {
  description = "Security group IDs for ALB"
  type        = list(string)
}

variable "s3_alb_logs" {
  description = "S3 Bucket for Application Loadbalancer Logs"
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

variable "target_type" {
  description = "Target Type for EC2 Target Group"
  type        = string
}

variable "instance_id" {
  description = "EC2 Instance ID"
  type        = string
}

variable "domain_name" {
  description = "value"
  type        = string
}

variable "ssl_policy" {
  description = "ALB SSL Policy"
  type        = string
}